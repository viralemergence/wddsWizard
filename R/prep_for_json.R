## This is a set of functions to convert properties to json

## for strings, numbers, boolean, anything thats not an array or object

#' Prepare atomic
#'
#'  This is a thin wrapper for `jsonlite::unbox`. It stops `jsonlite` from
#'  representing single character, numeric, logical, etc. items as arrays.
#'
#'  This is useful when a property or definition is of type string, number, logical and of length 1.
#'
#' @param x vector
#'
#' @returns an unboxed dataframe with 1 row
#' @export
#'
#' @examples
#'
#' x <- 1
#'
#' # values in x are stored in an array
#' x|>
#' jsonlite::toJSON()
#'  # output is [1]
#'
#' # values in x are NOT stored in an array (no square brackets)
#' prep_atomic(x) |>
#'   jsonlite::toJSON()
#'# output is 1
#'
prep_atomic <- function(x){
  if(is.data.frame(x)){
    if(nrow(x)>1){
      msg = "x is a data frame with more than 1 row. Not clear which item should
      be converted to atomic. Please provide either a single row, non-nested, data frame or
      a single value vector"
      rlang::abort(msg)
    }

    x<-x[1,1][[1]]

    if(!is.vector(x)){

      x_class<-class(x)

      msg = sprintf("x is a %s, not a vector. Not clear which item should
      be converted to atomic. Please provide either a single row,non-nested, data frame or
      a single value vector",x_class)
      rlang::abort(msg)
    }
  }

  if(length(x) != 1){
    msg = "x is not length 1, please provide a vector of length one"
    rlang::abort(msg)
  }

  jsonlite::unbox(x)
}

#' Prepare an array of objects
#'
#'  wraps a tibble/dataframe in a list and/or unboxes list items that are 1 row
#'  tibbles/dataframes. This will result in an array of objects being created.
#'
#'
#' @param x list of tibbles/data frames or a tibble/data frame
#'
#' @returns list of single row unboxed data frames
#' @export
#'
#' @examples
#'
#' # note that you cannot unbox data frames with more than 1 row
#'
#' x <- list(tibble::tibble(age = 1,group = letters[1]),
#'           tibble::tibble(age = 2,group = letters[2]))
#'
#' # running jsonlite::toJSON on an unmodified object results in
#' # extra square brackets - an array of arrays of objects
#' jsonlite::toJSON(x, pretty = TRUE)
#'
#' # with the prepped data we get an array of objects
#' x_prepped  <- prep_array_objects(x)
#'
#' x_prepped |>
#'   jsonlite::toJSON(pretty = TRUE)
#'
#'
prep_array_objects <- function(x){
  if(is.data.frame(x)){
    x <- list(x)
  }
purrr::map(x, jsonlite::unbox)
}

#' Prepare an object
#'
#'  Converts a named vector, list, or data frame to a list, and
#'  optionally unboxes it, so that its recorded as an object.
#'
#'  Note that unboxing will only work on items where you have 1:1 key value pair. So if you have a dataframe with multiple rows or a list  with
#'  multiple values at a given position, it won't work.
#'
#' @param x named vector, list, or data frame
#' @param unbox logical Should items be unboxed (not arrays)?
#'
#' @returns List of formatted objects
#' @export
#'
#' @examples
#'
#' cars_small  <- datasets::cars[1:10,]
#'
#' # creates an array of objects where each
#' # row is an object
#' cars_small |>
#'   jsonlite::toJSON(pretty = TRUE)
#'
#' # creates an object with 2 arrays
#' prep_object(cars_small) |>
#'   jsonlite::toJSON(pretty = TRUE)
#'
#' # this makes no difference
#' x <- list("hello" = 1:10, "world" = "Earth")
#'
#' prep_object(x) |>
#'   jsonlite::toJSON(pretty = TRUE)
#'
#'
prep_object <- function(x, unbox = FALSE){
  if(is.null(names)){
    msg <- "x must have names"
    rlang::abort()
  }

  if(is.matrix(x)){
    x <- as.data.frame(x)
  }

  x_list <- as.list(x)

  ## is this redundent with prep atomic?
  if(unbox){
    x_list <- purrr::map(x_list, jsonlite::unbox)
  }

  return(x_list)
}


#' Prepare descriptions
#'
#'   Wrapper for `prep_array_objects`.
#'
#' @param x Data frame/Tibble containing description items
#'
#' @returns List with x marked as unbox (do not make an array)
#' @export
#'
#' @examples
#'
#' x  <- wddsWizard::becker_project_metadata$descriptions
#'
#' prep_descriptions(x) |> jsonlite::toJSON()
#'
#'
prep_descriptions <- function(x){
  prep_array_objects(x)
}

#' Prep identifiers
#'
#' Prepare identifiers for a scholarly work. Wrapper for prep_array_objects
#'
#' @param x data frame with identifier properties
#'
#' @returns List with x marked as do not unbox
#' @export
#'
#' @examples
#'
#' wddsWizard::becker_project_metadata$identifiers |> prep_identifiers()
#'
prep_identifiers <- function(x){
  prep_array_objects(x)
}

#' Prepare related identifiers
#'
#' @param x data frame with related identifier properties
#'
#' @returns List with x marked as do not unbox
#' @export
#'
#' @examples
#'
#' wddsWizard::becker_project_metadata$relatedIdentifiers |> prep_relatedIdentifiers()
#'
prep_relatedIdentifiers <- function(x){
  prep_array_objects(x)
}


#' Prep language
#'
#'  Prepare the language property - this should describe the language
#'  of the scholarly work.
#'
#' @param x named list, vector, or data.frame of with 1:1 name:value pairs
#'
#' @returns an unboxed dataframe with 1 row
#' @export
#'
#' @examples
#'
#' a <- data.frame("language" = "en")
#'
#' prep_language(a)
#'
prep_language <- function(x){


  prep_atomic(x)
}

#' Prepare publication year items
#'
#'  wrapper for prep atomic
#'
#' @param x Named vector, data frame, or list
#'
#' @returns an unboxed dataframe with 1 row
#' @export
#'
#' @examples
#' pub_year <- data.frame("publicationYear" = "2025")
#'
#' prep_language(pub_year)
#'
#'
prep_publicationYear <- function(x){
  prep_atomic(x)
}



#' Prepare rights
#'
#'  Prepares an array of objects
#'
#' @param x named list, vector, or data.frame of with 1:1 name:value pairs
#'
#' @returns list of unboxed data frames
#' @export
#'
#' @examples
#'
#'  wddsWizard::becker_project_metadata$rights |> prep_rights()
#'
prep_rights <- function(x){
  prep_array_objects(x)
}



#' Prepare subjects
#'
#' Subjects or keywords describing a work. Prepares an array of objects
#'
#'
#' @param x named list, vector, or data.frame of with 1:1 name:value pairs
#'
#' @returns list of unboxed data frames
#' @export
#'
#' @examples
#' wddsWizard::becker_project_metadata$subjects |> prep_subjects()
#'
prep_subjects <- function(x){
    prep_array_objects(x)
}


#' prep affiliation
#'
#' There are affiliations associated with a creator.
#'
#' Affiliation in datacite is an array of objects
#' with properties name, affiliationIdentifier, affiliationIdentifierScheme,
#' and schemeURI. This function takes the affiliation fields and restructures
#' as a list within the dataframe.
#'
#' Affiliation fields to be converted to a list: "affiliation", #' "affiliationIdentifier",
#' "affiliationIdentifierScheme" ,
#' "schemeUri"
#'
#' @param x tibble from prep_creators
#'
#' @returns tibble with affilition fields in a list column called `affilition`
#' @export
#'
prep_affiliation <- function(x){
  # check if affiliation is already properly formatted...

  # create placeholder df
  aff_cols <- c("affiliation",
             "affiliationIdentifier" ,
             "affiliationIdentifierScheme" ,
             "schemeUri" )


  # get values from x
  aff_filter <- names(x) %in% aff_cols

  # jump out of the function if no affiliation fields present
  if(all(!aff_filter)){
    return(x)
  }

  x_aff <- x[aff_filter]
  # rename affiliation to name
  x_aff <- x_aff |>
    dplyr::rename("name"= "affiliation")

  # drop Affiliation columns then add nested column

  x_aff_nested <- x[!aff_filter]
  x_aff_nested$affiliation <- list(x_aff) ## not sure why prep_array_object doesnt work here...

  return(x_aff_nested)
}



#' Prepare Name identifiers
#'
#' These are Persistent identifiers associated with a creator.
#'
#' Name identifiers in datacite is an array of objects
#' with properties "nameIdentifier", "nameIdentifierScheme" ,
#' and "schemeUri". This function takes the `name identifiers` fields and restructures
#' as a list within the data frame.
#'
#' @param x Data frame from "creators"
#'
#' @returns data frame with a nameIdentifiers column as list
#' @export
#'
prep_nameIdentifiers <- function(x){

  # check if nameIdentifiers is already properly formatted...

  # name identifier object proprerties
  nid_cols <- c("nameIdentifier",
                "nameIdentifierScheme" ,
                "schemeUri" )


  # get values from x
  nid_filter <- names(x) %in% nid_cols

  # jump out of the function if no name identifiers fields present
  if(all(!nid_filter)){
    return(x)
  }

  # get name id cols
  x_nid <- x[nid_filter]

  # check for required nameIdentifierScheme

  if(!"nameIdentifierScheme" %in% names(x_nid)){
    x_nid$nameIdentifierScheme <- "ORCID"
  }

  # drop Affiliation columns then add nested column

  x_nid_nested <- x[!nid_filter]
  x_nid_nested$nameIdentifiers <- list(x_nid) ## not sure why prep_array_object doesnt work here...

  return(x_nid_nested)
}


#' Prepare creators
#'
#' The creator object can be complex so we prepare components of the final object (e.g. affiliation, nameIdentifiers) then run prep_array_objects
#'
#' @param x data frame or named list.
#'
#' @returns List of unboxed data frames
#' @export
#'
#' @examples
#'
#' wddsWizard::becker_project_metadata$creators |>
#'  prep_creators()
#'
prep_creators <- function(x){

  x_aff <- purrr::map(x,prep_affiliation)
  x_nid <- purrr::map(x_aff,prep_nameIdentifiers)
  out <- prep_array_objects(x_nid)

  return(out)
}

#' Prepare funding references
#'
#' creates an array of objects
#'
#' @param x list of tibbles/data frames or a tibble/data frame
#'
#' @returns list of single row unboxed data frames
#' @export
#'
#' @examples
#'
#' wddsWizard::becker_project_metadata$fundingReferences |>
#'  prep_fundingReferences()
prep_fundingReferences <- function(x){
  prep_array_objects(x)
}



## methodologoy this is a real object within the schema
#' Prep methodology for conversion to json
#'
#' @param x List. methodology component of a list
#'
#' @returns properly formatted list
#' @export
#'
#' @examples
#'
#'\dontrun{
#' prepped_list <- project_metadata_list_entities
#'  prepped_list$methodology <- prep_methodology(project_metadata_list_entities$methodology)
#'
#'  OR
#'
#'  prepped_list <- purrr::modify_at(project_metadata_list_entities,"methodology",prep_methodology)
#'}
#'
prep_methodology <- function(x){

  # set these to be explicitly logical
  x <- x |>
     dplyr::mutate(eventBased = as.logical(eventBased),
            archival=  as.logical(archival))

  prep_object(x,unbox = TRUE)
}



## titles is an array of objects

#' Prepare Titles
#'
#' Prepares an array of objects
#'
#' @inherit prep_array_objects
#' @export
#' @examples
#'
#' wddsWizard::becker_project_metadata$titles |>
#' prep_titles()
#'
prep_titles <- function(x){
  prep_array_objects(x)
}


#' Prepare Data
#'
#' Prepares an object of arrays.
#'
#' @inherit prep_object
#' @export
prep_data <- function(x){
  prep_object(x)
}


#' Prepare methods
#'
#' Collection of methods for preparing data conveniently named to make
#' preparing easier
#'
#' @returns list of methods
#' @export
#'
#' @examples
#'
#' prep_methods()
#'
prep_methods <- function(){
  list(
    data = prep_data,
    creators = prep_creators,
    descriptions = prep_descriptions,
    fundingReferences = prep_fundingReferences,
    identifiers = prep_identifiers,
    relatedIdentifiers = prep_relatedIdentifiers,
    language = prep_language,
    methodology = prep_methodology,
    publicationYear = prep_publicationYear,
    rights = prep_rights,
    subjects = prep_subjects,
    titles = prep_titles
  )
}


#' Prepare data for json
#'
#'  Uses`purrr::modify_at` to apply a set of methods at specific locations in a
#'  list.
#'
#' @param x list. Named list of data frames, lists, or vectors. For methods to be applied,
#' the names of the list items should match the names in the methods list
#' @param prep_methods_list list. Named list of methods where each items is a function to applied to corresponding items in x.
#'
#' @returns Named list where methods have been applied.
#' @export
#'
#' @examples
#'
#' wddsWizard::becker_project_metadata |>
#'    prep_for_json()
#'
#'  a <- list("hello_world" = 1:10 )
#'  methods_list <- list("hello_world" = function(x){x*2},
#'                        "unused_method" = function(x){x/2})
#'  prep_for_json(a,methods_list)
#'
#'
prep_for_json <- function(x,prep_methods_list = prep_methods()){

  # get methods we have for properties
  filter_methods <-  names(prep_methods_list) %in% names(x)
  subset_methods <- prep_methods_list[filter_methods]

  prepped_list <- x
  for(i in  1:length(subset_methods)){
    property <- names(prep_methods_list[i])
    property_method <- prep_methods_list[[i]]
    prepped_list <- purrr::modify_at(prepped_list,property,property_method)
  }

  return(prepped_list)
}


#' Get entity
#'
#' The `get_entity` function creates standard entities that will be easier to transform json.
#'
#' Pivots data from long to wide.
#'
#' @param x data frame. A "long" form data frame with the fields Group, entity_id, Value, and variable.
#'
#' @returns data frame in "wide" form
#' @export
#'
#' @examples
#'
#' df <- data.frame(Group = 1, entity_id = 1, Value = 1:3, Variable = letters[1:3])
#'
#' get_entity(df)
#'
#'
get_entity <- function(x){
  y <- x |>
    dplyr::select(-Group,-entity_id) |>
    dplyr::filter(Value != "") |>
    dplyr::mutate(Variable = snakecase::to_lower_camel_case(Variable))

  z <- tidyr::pivot_wider(y,names_from = Variable, values_from = Value)


  return(z)
}
