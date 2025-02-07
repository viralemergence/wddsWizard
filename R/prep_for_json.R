## This is a set of functions to convert properties to json


prepped_list <- project_metadata_list_entities

## for strings, numbers, boolean, anything thats not an array or object
prep_atomic <- function(x){
  jsonlite::unbox(x)
}


prep_array_objects <- function(x){
  if(tibble::is_tibble(x)){
    x <- list(x)
  }
purrr::map(x, jsonlite::unbox)
}

prep_object <- function(x){
  x_list <- as.list(x)
  purrr::map(x_list, jsonlite::unbox)
}

## prep_array_string

##

project_metadata_list_entities$descriptions

prep_descriptions <- function(x){
  x_list <- as.list(x)
  purrr::map_df(x_list, jsonlite::unbox)
}

prep_descriptions(project_metadata_list_entities$descriptions) |>
  jsonlite::toJSON()



project_metadata_list_entities$identifiers

#' Prep identifiers
#'
#' @param x List with identifier objects
#'
#' @returns
#' @export
#'
#' @examples
prep_identifiers <- function(x){
  prep_array_objects(x)
}

prep_identifiers(project_metadata_list_entities$identifiers) |>
  jsonlite::toJSON()



#' Prep language
#'
#' @param x
#'
#' @returns
#' @export
#'
#' @examples
prep_language <- function(x){
  prep_atomic(x)
}

prep_language(project_metadata_list_entities$language) |>
  jsonlite::toJSON()




prep_publicationYear <- function(x){
  prep_atomic(x)
}

prep_publicationYear(project_metadata_list_entities$publicationYear) |>
  jsonlite::toJSON()



prep_rights <- function(x){
  prep_array_objects(x)
}

project_metadata_list_entities$rights |>
  prep_rights() |>
  jsonlite::toJSON()

prep_subjects <- function(x){
    prep_array_objects(x)
}



project_metadata_list_entities$subjects |>
  prep_subjects()|>
  jsonlite::toJSON()




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

prep_creators <- function(x){
  x_aff <- purrr::map(x,prep_affiliation)
  prep_array_objects(x_aff)
}

project_metadata_list_entities$creators |>
  prep_creators() |>
  jsonlite::toJSON(pretty = T)





prep_fundingReferences <- function(x){
  prep_array_objects(x)
}

project_metadata_list_entities$fundingReferences |>
  prep_fundingReferences() |>
  jsonlite::toJSON(pretty = TRUE)



## methodologoy this is a real object within the schema
#' Prep methodology for conversion to json
#'
#' @param x List. methodology component of a list
#'
#' @returns properly fomatted list
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
  x_list <- as.list(x)
  purrr::map(x_list, jsonlite::unbox)
}



## titles is an array of objects

prep_titles <- function(x){
  prep_array_objects(x)
}

titles_prepped <- prep_titles(project_metadata_list_entities$titles)



titles_prepped |>
  jsonlite::toJSON()
