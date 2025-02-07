#' Title
#'
#' @param schema_path
#' @param property_types
#'
#' @returns
#' @export
#'
#' @examples
create_schema_type_map <- function(schema_path, property_types = data.frame(name = character(), value = character(), source = character())){
  # get schema
  print(sprintf("schema path: %s",schema_path))
  schema <- jsonlite::fromJSON(schema_path)

  property_types <- get_property_types(schema,property_types = property_types)

  dup_check <- duplicated(property_types$name)

  if(any(dup_check)){
    dup_names <- property_types$name[which(dup_check)] |>
      paste(collapse = ", ")

    msg <- sprintf("Duplicate names found!\n%s", dup_names)
    warning(msg)
  }

  return(property_types)
}

### potentially another function in here called get_property_types that can
## recursively work through all $ref calls - either internal in definitions or
## external in other files

get_property_types <- function(schema,
                               property_types = data.frame(name = character(),
                                                           value = character(),
                                                           source = character()),
                               definitions = NULL,
                               array_name = NULL){

  ## grab the major elements of the schema
  properties <- schema$properties
  # if definitions are supplied, we are likely in an object
  if(rlang::is_empty(definitions)){
    definitions <- schema$definitions
  }

  ## if there is an items element, that means we are in an array!
  items <- schema$items

  if(!rlang::is_empty(items)){
    print("array!")
    property_types <- process_array_items(schema,property_types)
  }

  property_types_list <- purrr::map_depth(properties,1,"type" )

  prop_types_df <- purrr::discard(property_types_list,is.null) |>
    as.data.frame() |>
    tidyr::pivot_longer(everything())

  prop_types_df$source <- "properties"
  # dig through array and obj type properties

  # dig through objects
  obj_names <- prop_types_df |>
    dplyr::filter(value == "object") |>
    dplyr::pull(name)

  if(!rlang::is_empty(obj_names)){
    print("in an object")
    # print(properties[obj_names])

    property_types <- purrr::map_df(properties[obj_names],get_property_types, property_types = property_types, definitions = definitions)
  }

  # dig through arrays

  array_names <- prop_types_df |>
    dplyr::filter(value == "array") |>
    dplyr::pull(name)

  if(!rlang::is_empty(array_names)){
    # browser()

    array_props  <- properties[array_names]

    array_list <<- purrr::imap(array_props,
                                  function(x,idx){
                                    get_property_types(schema =x ,
                                                       array_name = idx,
                                                       property_types = property_types)
                                  }



    )



  }

  # get any references
  property_refs <-  purrr::map_depth(properties,1,"$ref" )

  # this could result in multiple files, deal with it later, will likely need
  # to be recursive so that it can walk through multiple reference files and
  # any schemas they may reference

  property_refs_vec <- unlist(property_refs)

  external_types_df <- data.frame(name = character(), value = character(), source = character())
  internal_types_df <- data.frame(name = character(), value = character(),source = character())

  if(!rlang::is_empty(property_refs_vec)){

    # get file paths for external references -----
    external_refs <- property_refs_vec |>
      stringr::str_remove_all(pattern = '#.*') |>
      unique()

    # remove any empty references
    external_refs_full <- external_refs[external_refs != ""]

    if(!rlang::is_empty(external_refs_full)){
      print("get external properties")
      print(external_refs_full)
      external_types_df <- purrr::map_df(external_refs_full,create_schema_type_map,property_types = property_types )
    }

    # get internal definitions -----
    internal_refs <- property_refs_vec[
      stringr::str_starts(property_refs_vec,pattern = '#/definitions')
    ]

    if(!rlang::is_empty(internal_refs)){
      print("looking at internal refs")
      prop_internal_ref  <- names(internal_refs)
      def_internal_ref <- definitions[prop_internal_ref]
      def_internal_ref_types <- purrr::map_depth(def_internal_ref,1,"type" )

      internal_types_df <- purrr::discard(def_internal_ref_types,is.null) |>
        as.data.frame() |>
        tidyr::pivot_longer(everything())

      internal_types_df$source <- "internal"
    }
  }


  out <- rbind(property_types,prop_types_df,external_types_df,internal_types_df)

  return(out)

}


## may need to add in defs later
process_array_items <- function(schema,property_types){
  property_types_list <- purrr::map_depth(schema,1,"type" )
  # drop nulls
  drop_null_types <- property_types_list != "null"

  item_prop_types_df <- purrr::discard(property_types_list,is.null) |>
    as.data.frame() |>
    tidyr::pivot_longer(everything())
  item_prop_types_df$name <- array_name
  item_prop_types_df$source <- "array item"

  # print(item_prop_types_df)
  ##  what if an array property references a definition or external?
  property_types <- rbind(property_types,item_prop_types_df)

  print(property_types)
  return(property_types)
}
