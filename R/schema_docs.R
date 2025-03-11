#' Create Documentation for a schema
#'
#' Produces nested markdown that documents a schema. This is a
#' recursive set of function
#'
#' @param schema_path Character. Path to a json-schema
#' @param sep  Character. separator to be used by paste_reduce*
#'
#' @returns character vector of markdown text
#' @export
#'
#' @examples
#'
#' create_schema_docs()
#'
create_schema_docs <- function(schema_path = the$current_schema_path, sep = "\n"){


  # read in the json
  schema_list <- jsonlite::read_json(schema_path)
  # get any required fields
  required_fields <- get_required_fields(schema_list)
  # map over properties of the schema to build documents
  schema_docs <- purrr::imap(schema_list$properties,function(x,idx){
    create_object_docs(x,idx, required_fields =  required_fields, schema_dir = the$current_schema_dir)
  }
  ) |>
    purrr::reduce(paste_reduce,sep = sep,.dir = "backward")


  the$req_collapsed <- required_fields |>
    paste(collapse = ", ")

  return(schema_docs)
}

#' Get the required fields
#'
#'  Gets the required fields for an object or schema
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

  sprintf("create_object_docs: %s",idx) |>
    print()

  title <- idx
  type <- x$type

  description <- x$description

  if("examples" %in% names(x)){
    examples <- paste(x$examples , collapse = ", ")
    description <- sprintf("%s  \n**Example Values**: %s  ",description,examples)
  }

  if(rlang::is_empty(description)){

    description <- "Missing description. Please file an Issue."

    ## pull sub folder
    if(stringr::str_detect(the$current_schema_dir,"datacite")){
      query_url <- sprintf("https://datacite-metadata-schema.readthedocs.io/en/4.5/search/?q=%s&check_keywords=yes&area=default",title)
      description <- sprintf("[DataCite %s](%s)",title,query_url)
    }

    if(stringr::str_detect(the$current_schema_dir,"dwc")){
      description <- "see https://dwc.tdwg.org/list/"
    }

  }
  required <- idx %in% required_fields

  if(required){
    description <- sprintf('<span style="color: black;background-color: #ffc107;">REQUIRED</span> %s', description)
  }

  # process a reference
  if("$ref" %in% names(x)){

    reference_pointer <- x[["$ref"]]

    print("create_object_docs: reference in object")
    print(reference_pointer)

    x <- get_ref(x,schema_dir)

    # break out of the cycle if x is character
    if(is.character(x)){
      #add top level
      #reset the schema path
      the$current_schema_path <- the$parent_schema_path
      the$current_schema_dir <- the$parent_schema_dir

      ### add required fields
      ## title, type, description, required, reference, array items
      txt_out <- sprintf("## %s  \n**Type**: %s  \n**Description**: %s  \n**Required Fields**: %s  \n", title, "object", description, the$req_collapsed)

      out  <- sprintf("%s **Reference**: %s  \n\n%s \n", txt_out,reference_pointer,x)

      return(out)
    }
  }

  ## process arrays

  type <- x$type ## resetting type in case of a reference
  the$array_items <- x$items
  the$array_items_skip <- FALSE
  if(type == "array"){
    items  <- purrr::imap_chr(x$items,function(x,idx){
      # skip other array items if
      if(the$array_items_skip){
        return("")
      }
      # if its an object
      if((idx == "type" & "object" %in% x)){

        if("allOf" %in% names(the$array_items)){

          ## needed to check for properties
          the$array_items_parent <- the$array_items

          print("create_object_docs: allof in array_item")

          # get the allof reference
          x <- get_ref(the$array_items$allOf[[1]], the$current_schema_dir)
          x_required_fields <- unlist(x$required)

          # create the allof object documentation
          sub_object_allof <- purrr::imap(x$properties,\(x,idx) create_object_docs(x,idx,x_required_fields,schema_dir = the$current_schema_dir)) |>
            purrr::reduce(paste_reduce,.dir = "backward")

          sub_object_allof_d2 <-  increase_docs_depth(sub_object_allof)

          ## dropped description
          x_chr <- paste(sub_object_allof_d2,collapse = "\n")

          ## check if has properties
          if("properties" %in% names(the$array_items_parent)){
            required_fields_allof <- get_required_fields(the$array_items_parent)

            # create properties documentation
            sub_object_properties <- purrr::imap(the$array_items_parent$properties,\(x,idx) create_object_docs(x,idx,required_fields_allof, schema_dir = the$current_schema_dir)) |>
              purrr::reduce(paste_reduce,.dir = "backward")

            sub_object_properties_d2 <- increase_docs_depth(sub_object_properties)

            # mash to together all of and properties
            x_chr <- sprintf("%s  \n    %s",x_chr,sub_object_properties_d2)
          }
          the$array_items_skip <- TRUE
          return(x_chr)
        }

        required_fields_array <- get_required_fields(the$array_items)
        sub_object <- purrr::imap(the$array_items$properties,\(x,idx) create_object_docs(x,idx,required_fields_array, schema_dir = the$current_schema_dir)) |>
          purrr::reduce(paste_reduce, sep = "    ",.dir = "backward")

        x_chr <- stringr::str_replace(sub_object,pattern = "- ",replacement = "")
        the$array_items_skip <- TRUE
        return(x_chr)
      } else {
        x_chr <- unlist(x) |> paste(collapse = ", ")
        x_chr <- sprintf("**%s**: %s  ",idx, x_chr)
      }

      return(x_chr)
    })

    items_chr <- items |>
      purrr::keep(\(x)(x!="")) |>
      purrr::reduce(.f = paste_reduce_ul, sep = "\n    - ")

    description <- paste(description,"  \n**Array Items**\n    -",items_chr, collapse = "")
  }

  ### process objects
  if(type == "object"){
    required_fields_obj <- get_required_fields(x)
    sub_object <- purrr::imap(x$properties,\(x,idx) create_object_docs(x,idx,required_fields_obj, schema_dir = the$current_schema_dir)) |>
      purrr::reduce(paste_reduce_ul,sep = "    ",.dir = "backward")
    description <- sprintf("%s  \n**Properties**:  \n\n    %s", description,sub_object)
  }


  out  <- sprintf("- ### %s  \n**Type**: %s  \n**Description**: %s  \n", title,type, description)

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

#' Paste Reduce unordered list item
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
#' paste_reduce_ul(text_a,text_b)
#'
paste_reduce_ul <- function(x, y, sep = "\n - "){
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
  print("get_ref: pointer")
  print(reference)

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

    ## check to see if the ref is a ref
    if("allOf" %in% names(out)){
      print("get_ref: allof")
      print(out$allOf[[1]])
      ### get the reference...
      out <-  get_ref(out$allOf[[1]], the$current_schema_dir)
    }

    if("$ref" %in% names(out)){
      print("get_ref: $ref")
      print(out["$ref"][1])
      ### get the reference...slightly different structure
      out <-  get_ref(out["$ref"][1], the$current_schema_dir)
    }

  } else {

    out <- create_schema_docs(schema_path = the$current_schema_path, sep = "\n")

    # make it a sublist
    out <- sprintf("%s  \n",out)
  }

  return(out)
}


#' Increase documentation depth
#'
#' Pads the left side of any list items with an extra
#' 4 spaces
#'
#' @param string Character. item to be parsed
#'
#' @returns character
#' @export
increase_docs_depth <- function(string){

  ## increase depth for subitems
  string_d1 <- stringr::str_replace_all(string,pattern = "\n    - #",replacement = "\n        - #")

  ## increase depth for items
  string_d2 <- stringr::str_replace_all(string_d1,pattern = "\n- #",replacement = "\n    - #")

  return(string_d2)
}

