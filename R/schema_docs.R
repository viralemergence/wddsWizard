### starting from some schema
### work your way through
### keep track of the schema you're in with the$current_schema_path


#' Create Documentation for a schema
#'
#' Produces nested markdown that documents a schema
#'
#' @param schema_path Character. Path to a json-schema
#'
#' @returns character vector of markdown text
#' @export
#'
#' @examples
#'
#' create_schema_docs()
#'
create_schema_docs <- function(schema_path = the$current_schema_path){
  schema_list <- jsonlite::read_json(schema_path)
  required_fields <- get_required_fields(schema_list)

  schema_docs <- purrr::imap(schema_list$properties,function(x,idx){
    create_object_docs(x,idx, required_fields =  required_fields, schema_dir = the$current_schema_dir)
  }
  ) |>
    purrr::reduce(paste_reduce,.dir = "backward")

  return(schema_docs)
}

#' Get the required fields for a schema
#'
#'  Gets the required fields for an object
#'
#' @param schema_list List from jsonlite::read_json
#'
#' @returns character vector of required fields
#' @export
get_required_fields <- function(schema_list){

  required_fields <- ""

  if("required" %in% names(schema_list)){
    required_fields <- unlist(schema_list$required)
  }

  return(required_fields)
}

#' Create Docs Section for a schema object
#'
#' @param x List. Schema property or definition
#' @param idx Name from schema property
#' @param required_fields Character. Vector of required fields
#' @param schema_dir Character. directory where the schema is stored
#'
#' @returns Character formatted markdown text
#' @export
create_object_docs <- function(x,idx, required_fields, schema_dir){
  print(idx)
  title <- idx

  # if(idx == "publicationYear"){
  #   browser()
  # }

  if("$ref" %in% names(x)){
    # if(title == "titles"){
    #   browser()
    # }
    x <- get_ref(x,schema_dir)

    # break out of the cycle if x is character
    if(is.character(x)){
      #reset the schema path
      the$current_schema_path <- the$parent_schema_path
      the$current_schema_dir <- the$parent_schema_dir
      return(x)
    }
  }

  type <- x$type
  description <- x$description
  if(rlang::is_empty(description)){

    description <- "Missing description. Please file an Issue."

    ## pull sub folder
    if(stringr::str_detect(the$current_schema_dir,"datacite")){
      description <- "see https://datacite-metadata-schema.readthedocs.io/en/4.5/properties/"
    }

    if(stringr::str_detect(the$current_schema_dir,"dwc")){
      description <- "see https://dwc.tdwg.org/list/"
    }

  }
  required <- idx %in% required_fields

  if(required){
    description <- sprintf("**REQUIRED** %s", description)
  }



  if(type == "array"){

    items  <- purrr::imap_chr(x$items,function(x,idx){

      # if its an object
      if((idx == "type" & "object" %in% x)){
        if(is.atomic(x)){
          # okay so this object is an empty husk that references a definition
          return("")
        }

        sub_object <- purrr::imap(x,\(x,idx) create_object_docs(x,idx,required_fields)) |>
          purrr::reduce(paste_reduce,.dir = "backward")

        x_chr <- paste(description,"<details><summary> Array Items </summary> *",sub_object,"</details>",collapse = "")
      } else if(
        (idx == "allOf" & "$ref" %in% names(x[[1]]))
      ){

        x <- get_ref(x[[1]], the$current_schema_dir)
        x_required_fields <- unlist(x$required)
        sub_object <- purrr::imap(x$properties,\(x,idx) create_object_docs(x,idx,x_required_fields)) |>
          purrr::reduce(paste_reduce,.dir = "backward")

        x_chr <- paste(description,"<details><summary> Array Items </summary> *",sub_object,"</details>",collapse = "")
      } else {
        x_chr <- unlist(x) |> paste(collapse = ", ")
        x_chr <- sprintf("**%s**: %s  ",idx, x_chr)
      }

      return(x_chr)
    }) |>
      purrr::reduce(.f = paste_reduce)
    description <- paste(description,"<details><summary> Array Items </summary> *",items,"</details>",collapse = "")
  }

  out  <- sprintf("### %s  \n **Type**: %s  \n **Description**: %s  ", title,type, description)

  return(out)
}




#' Paste Reduce
#'
#' A paste function that can be used with `purrr::reduce` to build up nested
#' documentation items
#'
#' @param x Character
#' @param y Character
#' @param sep Character
#'
#' @returns Character
#' @export
#'
#' @examples
#'
#' text_a <- "hello"
#' text_b <- "world"
#' paste_reduce(text_a,text_b)
#'
paste_reduce <- function(x, y, sep = "\n"){
  paste(x, y, sep = sep)
}

#' Get schema references
#'
#' Parses $ref calls in a schema. Can retrieve internal ('"$ref":"#/definitions/someDef") or
#' external references ('"$ref":"schemas/datacite/datacite.json"').
#'
#' For external references, it can handle both pointers and references to entire schemas.
#' This function navigates between parent and child schemas by manipulating
#' variables in the  package environment `the`.
#'
#' @param x List. Must have property "$ref"
#' @param schema_dir Character. Directory for the current schema.
#'
#' @returns List or Character. Character is only returned if an entire schema is referenced.
#' @export
get_ref <- function(x,schema_dir){

  # get the reference
  reference <- x[["$ref"]]

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

  # check if its a component
  component <- stringr::str_detect(reference,"#/.*$")

  if(component){
    # get component
    component_name <- stringr::str_extract(reference,"#/.*$")
    component_list <- stringr::str_split(component_name, pattern = "/",n = 3,simplify = FALSE) |>
      unlist()
    out <- sub_list[[component_list[2]]][[component_list[3]]]

    ## check to see if the ref is a ref... which is dumb
    if("allOf" %in% names(out)){
      ### get the reference...
      out <-  get_ref(out$allOf[[1]], the$current_schema_dir)
    }

    if("$ref" %in% names(out)){
      # browser()
      ### get the reference...
      out <-  get_ref(out["$ref"][1], the$current_schema_dir)
    }

  } else {
    print("get full schema?")
    out <- create_schema_docs(schema_path = the$current_schema_path)
  }

  return(out)
}


#
# purrr::imap(wddsWizard::disease_data_schema$properties,create_object_docs) |>
#   purrr::reduce(paste_reduce,.dir = "backward") |>
#   cat()
#
#
# purrr::imap(datacite_schema$properties["creators"], \(x, idx)create_object_docs(x = x,idx = idx,required_fields = wddsWizard::project_metadata_required_fields) ) |>
#   purrr::accumulate(paste_reduce)



