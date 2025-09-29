#' Wildlife Disease Data Standard
#'
#' See data standard JSON file for field descriptions.
#' @family Schema
"wdds_schema"

#' Wildlife Disease Data Standard - data
#'
#'
#' See data standard JSON file for field descriptions.
#' @family Schema
"disease_data_schema"

#' Wildlife Disease Data Standard - project_metadata
#'
#'
#' See data standard JSON file for field descriptions.
#' @family Schema
"project_metadata_schema"

#' Datacite Data Stadnard
#'
#'
#' See data standard JSON file for field descriptions.
#' @family Schema
"datacite_schema"


#' Wildlife Disease Data Standard - schema properties
#'
#'
#' A data frame of schema names and types.
#' @family Schema
"schema_properties"

#' Wildlife Disease Data Standard - schema terms
#'
#'
#' Markdown of schema terms
#' @family Schema
"schema_terms"

#' @title Schema Object
#'
#' @description
#' A class for getting schema properties.

schema_obj <- R6::R6Class("schema_obj", public = list(
  #' @field schema_path (`character(1)`)\cr
  #' path to the schema file.
  schema_path = NULL,
  #' @field schema_list_out (`list()`)\cr
  #' List of data frames with schema properties.
  schema_list_out = list(),
  #' @field wdds_version (`character(1)`)\cr
  #' version of wdds used
  wdds_version = NULL,
  #' @field current_schema_path (`character(1)`)\cr
  #' current schema file path
  current_schema_path = NULL,
  #' @field current_schema_dir (`character(1)`)\cr
  #' current schema directory path
  current_schema_dir = NULL,
  #' @field current_sub_schema_dir (`character(1)`)\cr
  #' current sub schema directory path
  current_sub_schema_dir = NULL,
  #' @field parent_schema_path (`character(1)`)\cr
  #' parent schema file path
  parent_schema_path = NULL,
  #' @field parent_schema_dir (`character(1)`)\cr
  #' parent schema directory
  parent_schema_dir = NULL,
  #' @field array_items (`c()`)\cr
  #' array items
  array_items = NULL,
  #' @field array_items_skip (`logical(1)`)\cr
  #' array items to skip
  array_items_skip = NULL,
  #' @field array_items_parent (`logical(1)`)\cr
  #' parent array items
  array_items_parent = NULL,

#' @param schema_path Character. File path for the schema (`character(1)`)\cr
#' @param wdds_version Character. Version of wdds used (`character(1)`)\cr
#'
#' @description
#' Creates a new instance of this [R6][R6::R6Class] class.
#'
  initialize = function(schema_path, wdds_version = "latest") {
      assertthat::assert_that(fs::file_exists(schema_path), msg = "schema_path must be a file that exists")
    self$current_schema_path = schema_path
    self$current_schema_dir <- fs::path_dir(schema_path)
    self$current_sub_schema_dir <- fs::dir_ls(path = self$current_schema_dir,type = "directory")
    self$wdds_version <- wdds_version
  },

  #' @description
  #' Create an expanded schema object
  #'
  #' Produces a list of data frame with name and type for the schema.
  #' This is a recursive set of function and may be expanded to get other properties.
  #'
  #' @param schema_path Character. Path to a json-schema. Default is the current
  #' schema path from the package environment,
  #'
  #' @returns List of of data frames.
  create_schema_list = function(schema_path = self$current_schema_path) {
    assertthat::assert_that(fs::file_exists(schema_path), msg = "schema_path must resolve to a file. See fs::file_exists")

    # read in the json
    schema_list <- jsonlite::read_json(schema_path)

    # map over properties of the schema to build documents
    schema_list_out <- purrr::imap(schema_list$properties, function(x, idx) {
      self$create_object_list(x,
                         idx,
                         schema_dir = self$current_schema_dir
      )
    })

    self$schema_list_out <- schema_list_out
    return(schema_list_out)
  },
  #' Create a list from a schema object
  #'
  #' Creates a data.frame with the fields name and type
  #'
  #' @param x List. Schema property or definition
  #' @param idx Name from schema property
  #' @param schema_dir Character. directory where the schema is stored
  #' @returns data frame with type and name
  create_object_list = function(x, idx, schema_dir) {
    # this is the final shape of our data
    out <- data.frame(
      name = "",
      type = ""
    )

    # name of our data
    out$name <- idx

    cli::cli_alert_info(sprintf("create_object_list: for object %s", idx))


    # process a reference ----
    if ("$ref" %in% names(x)) {
      reference_pointer <- x[["$ref"]]

      cli::cli_alert_info("create_object_list: reference in object")
      cli::cli_alert_info(reference_pointer)

      x <- self$get_ref_list(x, schema_dir)

      # break out of the cycle if x is a whole schema
      if (all(x$whole_schema)) {
        # reset the schema path
        self$current_schema_path <- self$parent_schema_path
        self$current_schema_dir <- self$parent_schema_dir
        sub_schema <- purrr::discard_at(x, "whole_schema") |>
          purrr::list_rbind()

        out$type <- "object"
        out$name <- idx
        out <- rbind(out, sub_schema)
        return(out)
      }

      if (is.data.frame(x)) {
        out <- purrr::discard_at(x, "whole_schema")
        return(out)
      }
    }


    # process arrays ----

    out$type <- x$type
    self$array_items <- x$items
    self$array_items_skip <- FALSE
    if (out$type == "array") {
      out <- self$process_array_items(x$items, out)

      return(out)
    }

    ### process objects ----
    if (out$type == "object") {
      cli::cli_alert_info("create_object_list: process object")
      cli::cli_alert_info(idx)

      sub_object <- purrr::imap(x$properties, \(x, idx) self$create_object_list(x, idx, schema_dir = self$current_schema_dir)) |>
        purrr::list_rbind()

      out <- rbind(out, sub_object)
    }

    return(out)
  },
  #' Get schema references
  #'
  #' Parses $ref calls in a schema. Can retrieve internal ('"$ref":"#/definitions/someDef") or
  #' external references ('"$ref":"schemas/datacite/datacite.json"').
  #'
  #' For external references, it can handle both pointers and references to entire schemas.
  #' This function navigates between parent and child schemas by manipulating
  #' variables in the package environment `the`.
  #'
  #' @param x List. Must have property "$ref"
  #' @param schema_dir Character. Directory for the current schema.
  #' @returns data frame with name or type.
  get_ref_list = function(x, schema_dir) {
    # get and cli::cli_alert_info the reference
    reference <- x[["$ref"]]
    cli::cli_alert_info("get_ref_list: pointer")
    cli::cli_alert_info(reference)


    # assume its not an external reference
    external_reference <- FALSE
    # check if the schema is internal or external
    if (stringr::str_detect(reference, "\\.json")) {
      sub_path <- sprintf("%s/%s", schema_dir, reference)
      sub_path_json <- stringr::str_remove(sub_path, "#.*")
      # if the file doesnt exist, try to repair the path by stepping the
      # dir up to the parent
      if (!file.exists(sub_path_json)) {
        sub_path <- sprintf("%s/%s", self$parent_schema_dir, reference)
        sub_path_json <- stringr::str_remove(sub_path, "#.*")
      }

      # check if the reference file matches the current path
      external_reference <- sub_path_json != self$current_schema_path
    }

    # get full schema
    if (external_reference) {
      # update environment variables
      self$parent_schema_path <- self$current_schema_path
      self$parent_schema_dir <- self$current_schema_dir
      self$current_schema_path <- sub_path_json
      sub_dir <- fs::path_dir(sub_path_json)
      self$current_schema_dir <- sub_dir

      sub_list <- jsonlite::read_json(path = sub_path_json)
    } else {
      # get full schema internal - this is necessary for defs
      sub_list <- jsonlite::read_json(self$current_schema_path)
    }

    # check if its a component of the schema
    component <- stringr::str_detect(reference, "#/.*$")

    if (component) {
      # get component
      component_name <- stringr::str_extract(reference, "#/.*$")
      component_list <- stringr::str_split(component_name, pattern = "/", n = 3, simplify = FALSE) |>
        unlist()
      ## here out is a list
      out <- sub_list[[component_list[2]]][[component_list[3]]]
      out$name <- component_list[3]

      ## check for references in out
      if ("$ref" %in% names(out)) {
        cli::cli_alert_info("get_ref_list: $ref")
        cli::cli_alert_info(out["$ref"][1])
        ### get the reference...slightly different structure
        out <- self$get_ref_list(out["$ref"][1], self$current_schema_dir)
        out <- as.data.frame(out[c("name", "type")])
        out$whole_schema <- FALSE
        return(out)
      }

      ## check for allof in out
      if ("allOf" %in% names(out)) {
        cli::cli_alert_info("get_ref_list: allof")
        cli::cli_alert_info(out$allOf[[1]])
        ### get the reference...
        out <- self$get_ref_list(out$allOf[[1]], self$current_schema_dir)
      }

      if (length(out$type) > 1) {
        cli::cli_alert_info("get_ref_list: length(out) > 1")
        cli::cli_alert_info(class(out))
        cli::cli_alert_info(names(out))

        return(out)
      }

      ## check if out is of type object
      if (out$type == "object") {
        cli::cli_alert_info("get_ref_list: process object")
        sub_object <- purrr::imap(out$properties, \(x, idx) self$create_object_list(x, idx, schema_dir = self$current_schema_dir)) |>
          purrr::list_rbind()

        return(sub_object)
      }

      # process out if its an array?
      # setup a data frame for proper processing
      out_df <- as.data.frame(out[c("name", "type")])

      if (out$type == "array") {
        cli::cli_alert_info("get_ref_list: process array")
        self$array_items <- out$items
        self$array_items_skip <- FALSE
        out <- self$process_array_items(out$items, out = out_df)
      }
    } else {
      ## process a whole schema

      cli::cli_alert_info("get_ref_list: process whole schema")
      out <- self$create_schema_list(schema_path = self$current_schema_path)
      out$whole_schema <- TRUE
      return(out)
    }

    out <- data.frame(name = out$name, type = out$type)

    out$whole_schema <- FALSE

    return(out)
  },
  #' Process Array Items
  #'
  #' Processes array items so they can be added to a data frame.
  #'
  #' @param array_items list. List of array items for processing.
  #' @param out data frame. Data frame with name and type.
  #' @returns data frames with name and type for array items that are objects or character strings atomic (string, null, Boolean, etc) array items.
  process_array_items = function(array_items, out){
    items <- purrr::imap(array_items, function(x, idx) {
      # skip other array items if
      if (self$array_items_skip) {
        return("")
      }

      # if its an object
      if ((idx == "type" & "object" %in% x)) {
        if ("allOf" %in% names(self$array_items)) {
          ## needed to check for properties
          self$array_items_parent <- self$array_items
          cli::cli_alert_info("process_array_items: allof in array_item")
          x <- self$get_ref_list(self$array_items$allOf[[1]], self$current_schema_dir)
          sub_object_allof <- purrr::imap(x$properties, \(x, idx) self$create_object_list(x, idx, schema_dir = self$current_schema_dir)) |>
            purrr::list_rbind()

          ## check if it also has properties

          if ("properties" %in% names(self$array_items_parent)) {
            sub_object_properties <- purrr::imap(self$array_items_parent$properties, \(x, idx) self$create_object_list(x, idx, schema_dir = self$current_schema_dir)) |>
              purrr::list_rbind()

            # mash to together all of and properties

            sub_object_allof <- rbind(sub_object_allof, sub_object_properties)
          }

          return(sub_object_allof)
        }


        cli::cli_alert_info("process_array_items: process object")
        sub_object <- purrr::imap(self$array_items$properties, \(x, idx) self$create_object_list(x, idx, schema_dir = self$current_schema_dir)) |>
          purrr::list_rbind()

        self$array_items_skip <- TRUE
        return(sub_object)
      } else {
        chr_out <- x |>
          purrr::reduce(paste_reduce, sep = ", ")
      }

      return(chr_out)
    })


    if (is.character(items$type)) {
      out$type <- paste(out$type, items$type, sep = ", ")
    } else {
      if (inherits(items$type, "data.frame")) {
        sub_obj_df <- items$type
      } else {
        sub_obj_df <- items$type |> purrr::list_rbind()
      }

      out <- rbind(out, sub_obj_df)
    }
    return(out)
  }
)
)



