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
#' @returns
#' @export
#'
#' @examples
#'
#' x <- c("hello" = 1)
#'
#' # values in "hello" are stored in an array
#' x|>
#' jsonlite::toJSON()
#'  # output is [1]
#'
#' # values in "hello" are NOT stored in an array (no square brackets)
#' prep_atomic(x) |>
#'   jsonlite::toJSON()
#'
#'  # output is {hello:1}
#'
#'
prep_atomic <- function(x){
  if(is.vector(x)){
     nm <- names(x)
     names(x) <- NULL
    x <- as.data.frame(x,nm = nm)
  }
  jsonlite::unbox(x)
}

#' Prepare an array of objects
#'
#'  wraps a tibble/dataframe in a list OR unboxes list items that are
#'  tibbles/dataframes. This will result in an array of objects being created.
#'
#'
#' @param x list of tibbles/data frames or tibbles/data frame
#'
#' @returns
#' @export
#'
#' @examples
#'
#' x <- list(numbers_df = tibble::tibble(age = 1:10),
#' letters_df = tibble::tibble(group = letters[1:5]))
#'
#' # running jsonlite::toJSON on an unmodified object results in
#' # extra square brackets - an array of arrays of objects
#' jsonlite::toJSON(x, pretty = TRUE)
#'
#' # with the prepped data we get an array of objects
#' x_prepped  <- prep_array_objects(x)
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
#' @returns
#' @export
#'
#' @examples
prep_object <- function(x, unbox = FALSE){
  if(is.null(names)){
    msg <- "x must have names"
    rlang::abort()
  }

  if(is.matrix(x)){
    x <- as.data.frame(x)
  }

  x_list <- as.list(x)

  if(unbox){
    x_list <- purrr::map(x_list, jsonlite::unbox)
  }

  return(x_list)
}

## prep_array_atomic

#' Prep an object with arrays
#'
#' Special case of prep_object where we know that the output
#' must be an object with arrays in the key value pairs.
#'
#' @param x A named list, data frame, or vector
#'
#' @returns
#' @export
#'
#' @examples
prep_object_arrays <- function(x){

  if(is.null(names)){
    msg <- "x must have names"
    rlang::abort()
  }

  x_list <- purrr::map(x,as.list)
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
prep_descriptions <- function(x){
  prep_array_objects(x)
}

#' Prep identifiers
#'
#' Wrapper for prep_array_objects
#'
#' @param x data frame with identifier properties
#'
#' @returns List with x marked as do not unbox
#' @export
#'
#' @examples
prep_identifiers <- function(x){
  prep_array_objects(x)
}

#' Prep language
#'
#'
#' @param x named list, vector, or data.frame of with 1:1 name:value pairs
#'
#' @returns
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
#' @returns
#' @export
#'
#' @examples
prep_publicationYear <- function(x){
  prep_atomic(x)
}



#' Prepare rights
#'
#'  Prepares an array of objects
#'
#' @param x
#'
#' @returns
#' @export
#'
#' @examples
prep_rights <- function(x){
  prep_array_objects(x)
}



#' Prepare subjects
#'
#' Prepares an array of objects
#'
#'
#' @param x
#'
#' @returns
#' @export
#'
#' @examples
prep_subjects <- function(x){
    prep_array_objects(x)
}


#' prep affiliation
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
#' @examples
prep_affiliation <- function(x){

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

#' Prepare creators
#'
#' The creator object can be complex so we prepare components of the final object (e.g. affiliation) then run prep_array_objects
#'
#' @param x data frame or named list.
#'
#' @returns
#' @export
#'
#' @examples
prep_creators <- function(x){
  x_aff <- purrr::map(x,prep_affiliation)
  prep_array_objects(x_aff)
}





#' Prepare funding references
#'
#' creates an array of objects
#'
#' @param x
#'
#' @returns
#' @export
#'
#' @examples
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
  prep_object(x,unbox = TRUE)
}



## titles is an array of objects

prep_titles <- function(x){
  prep_array_objects(x)
}


prep_data <- function(x){
  prep_object_arrays(x)
}


prep_methods <- function(){
  list(
    creators = prep_creators,
    descriptions = prep_descriptions,
    fundingReferences = prep_fundingReferences,
    identifiers = prep_identifiers,
    language = prep_language,
    methodology = prep_methodology,
    publicationYear = prep_publicationYear,
    rights = prep_rights,
    subjects = prep_subjects,
    titles = prep_titles
  )
}


prep_for_json <- function(x,prep_methods_list = prep_methods()){

  # get methods we have for properties
  filter_methods <-  names(prep_methods_list) %in% names(x)
  subset_methods <- prep_meth_list[filter_methods]

  prepped_list <- x
  for(i in  1:length(subset_methods)){
    property <- names(prep_methods_list[i])
    property_method <- prep_methods_list[[i]]
    prepped_list <- purrr::modify_at(prepped_list,property,property_method)
  }

  return(prepped_list)
}

prep_for_json(x) |>
  jsonlite::toJSON(pretty  = TRUE)

