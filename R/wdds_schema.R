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

#' Create an expanded schema object
#'
#' Produces a list of data frame with name and type for the schema.
#' This is a recursive set of function and may be expanded to get other properties.
#'
#' @param schema_path Character. Path to a json-schema. Default is the current
#' schema path from the package environment,
#'
#' @returns character vector of markdown text
#' @export
#' @family Schema
#' @examples
#'
#' create_schema_list()
#'
create_schema_list <- function(schema_path = the$current_schema_path){

  assertthat::assert_that(fs::file_exists(schema_path), msg = "schema_path must resolve to a file. See fs::file_exists")

  # read in the json
  schema_list <- jsonlite::read_json(schema_path)

  # map over properties of the schema to build documents
  schema_list_out <- purrr::imap(schema_list$properties,function(x,idx){
    create_object_list(x,
                       idx,
                       schema_dir = the$current_schema_dir)
  }
  )

  return(schema_list_out)
}

#' Create a list from a schema object
#'
#' Creates a data.frame with the fields name and type
#'
#' @param x List. Schema property or definition
#' @param idx Name from schema property
#' @param schema_dir Character. directory where the schema is stored
#' @family Schema
#' @returns data frame with type and name
create_object_list <- function(x,idx, schema_dir){

  # this is the final shape of our data
  out <- data.frame(name = "",
              type = "")

  # name of our data
  out$name <- idx

  print(sprintf("create_object_list: for object %s",idx))


  # process a reference ----
  if("$ref" %in% names(x)){

    reference_pointer <- x[["$ref"]]

    print("create_object_list: reference in object")
    print(reference_pointer)

    x <- get_ref_list(x,schema_dir)

    # break out of the cycle if x is a whole schema
    if(all(x$whole_schema)){
      #reset the schema path
      the$current_schema_path <- the$parent_schema_path
      the$current_schema_dir <- the$parent_schema_dir
      sub_schema <- purrr::discard_at(x,"whole_schema") |>
        purrr::list_rbind()

      out$type <- "object"
      out$name <- idx
      out  <- rbind(out,sub_schema)
      return(out)
    }

    if(is.data.frame(x)){
      out  <- purrr::discard_at(x,"whole_schema")
      return(out)
    }

  }


  # process arrays ----

  out$type <- x$type
  the$array_items <- x$items
  the$array_items_skip <- FALSE
  if(out$type == "array"){
    out  <- process_array_items(x$items, out)

    return(out)

  }

  ### process objects ----
  if(out$type == "object"){

    print("create_object_list: process object")
    print(idx)

    sub_object <- purrr::imap(x$properties,\(x,idx) create_object_list(x,idx, schema_dir = the$current_schema_dir)) |>
      purrr::list_rbind()

    out <- rbind(out, sub_object)
  }

  return(out)
}

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
#' @family Schema
#' @returns data frame with name or type.
#'
get_ref_list <- function(x,schema_dir){

  # get and print the reference
  reference <- x[["$ref"]]
  print("get_ref_list: pointer")
  print(reference)

  # assume its not an external reference
  external_reference<- FALSE
  # check if the schema is internal or external
  if(stringr::str_detect(reference,"\\.json")){
    sub_path <- sprintf("%s/%s",schema_dir, reference)
    sub_path_json <- stringr::str_remove(sub_path,"#.*")
    # if the file doesnt exist, try to repair the path by stepping the
    # dir up to the parent
    if(!file.exists(sub_path_json)){
      sub_path <- sprintf("%s/%s",the$parent_schema_dir, reference)
      sub_path_json <- stringr::str_remove(sub_path,"#.*")
    }

    # check if the reference file matches the current path
    external_reference <- sub_path_json!=the$current_schema_path
  }

  # get full schema
  if(external_reference){

    # update environment variables
    the$parent_schema_path <- the$current_schema_path
    the$parent_schema_dir <- the$current_schema_dir
    the$current_schema_path <- sub_path_json
    sub_dir <- fs::path_dir(sub_path_json)
    the$current_schema_dir <-sub_dir

    sub_list <- jsonlite::read_json(path = sub_path_json)
  } else {
    # get full schema internal - this is necessary for defs
    sub_list <- jsonlite::read_json(the$current_schema_path)
  }

  # check if its a component of the schema
  component <- stringr::str_detect(reference,"#/.*$")

  if(component){
    # get component
    component_name <- stringr::str_extract(reference,"#/.*$")
    component_list <- stringr::str_split(component_name, pattern = "/",n = 3,simplify = FALSE) |>
      unlist()
    ## here out is a list
    out <- sub_list[[component_list[2]]][[component_list[3]]]
    out$name <- component_list[3]

    ## check for references in out
    if("$ref" %in% names(out)){
      print("get_ref_list: $ref")
      print(out["$ref"][1])
      ### get the reference...slightly different structure
      out <-  get_ref_list(out["$ref"][1], the$current_schema_dir)
      out <- as.data.frame(out[c("name","type")])
      out$whole_schema <- FALSE
      return(out)
    }

    ## check for allof in out
    if("allOf" %in% names(out)){
      print("get_ref_list: allof")
      print(out$allOf[[1]])
      ### get the reference...
      out <-  get_ref_list(out$allOf[[1]], the$current_schema_dir)
    }

    if(length(out$type) > 1){
      print("get_ref_list: length(out) > 1")
      print(class(out))
      print(names(out))

      return(out)
    }

    ## check if out is of type object
    if(out$type == "object"){
      print("get_ref_list: process object")
      sub_object <- purrr::imap(out$properties,\(x,idx) create_object_list(x,idx, schema_dir = the$current_schema_dir)) |>
        purrr::list_rbind()

      return(sub_object)
    }

    # process out if its an array?
    # setup a data frame for proper processing
    out_df <- as.data.frame(out[c("name","type")])

    if(out$type == "array"){

      print("get_ref_list: process array")
      the$array_items <- out$items
      the$array_items_skip <- FALSE
      out <- process_array_items(out$items,out = out_df)
    }

  } else {
    ## process a whole schema

    print("get_ref_list: process whole schema")
    out <- create_schema_list(schema_path = the$current_schema_path)
    out$whole_schema <- TRUE
    return(out)
  }

  out <- data.frame(name = out$name, type = out$type)

  out$whole_schema <- FALSE

  return(out)
}


#' Process Array Items
#'
#' Processes array items so they can be added to a data frame.
#'
#' @param array_items list. List of array items for processing.
#' @param out data frame. Data frame with name and type.
#' @family Schema
#' @returns data frames with name and type for array items that are objects or character strings atomic (string, null, Boolean, etc) array items.
#'
process_array_items <- function(array_items, out){
  items <- purrr::imap(array_items,function(x,idx){

    # skip other array items if
    if(the$array_items_skip){
      return("")
    }

    # if its an object
    if((idx == "type" & "object" %in% x)){

      if("allOf" %in% names(the$array_items)){
        ## needed to check for properties
        the$array_items_parent <- the$array_items
        print("process_array_items: allof in array_item")
        x <- get_ref_list(the$array_items$allOf[[1]], the$current_schema_dir)
        sub_object_allof <- purrr::imap(x$properties,\(x,idx) create_object_list(x,idx,schema_dir = the$current_schema_dir)) |>
          purrr::list_rbind()

        ## check if it also has properties

        if("properties" %in% names(the$array_items_parent)){

          sub_object_properties <- purrr::imap(the$array_items_parent$properties,\(x,idx) create_object_list(x,idx, schema_dir = the$current_schema_dir)) |>
            purrr::list_rbind()

          # mash to together all of and properties

          sub_object_allof <- rbind(sub_object_allof,sub_object_properties)
        }

        return(sub_object_allof)
      }


      print("process_array_items: process object")
     sub_object <- purrr::imap(the$array_items$properties,\(x,idx) create_object_list(x,idx, schema_dir = the$current_schema_dir)) |>
        purrr::list_rbind()

      the$array_items_skip <- TRUE
      return(sub_object)
    } else {

      chr_out <-  x |>
        purrr::reduce(paste_reduce,sep = ", ")

    }

    return(chr_out)
  })


  if(is.character(items$type)){
    out$type <- paste(out$type,items$type,sep = ", ")
  } else {

    if(inherits(items$type,"data.frame")){
      sub_obj_df <- items$type
    } else {
      sub_obj_df <- items$type |> purrr::list_rbind()
    }

    out <- rbind(out,sub_obj_df)
  }
  return(out)
}

