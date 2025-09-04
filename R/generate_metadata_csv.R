#' Generate minimal project metadata template
#'
#' This function allows you to generate a minimal metadata template for your project.
#' You provide certain values and it generates a csv based on those values.
#' Any parameter that starts with num takes an integer and creates repeat entries in the metadata csv.
#' All other values take a string or logical input and will prepopulate that section of the metadata csv.
#'
#' @param file_path String. Where should the CSV file be saved?
#' @param event_based Logical. Whether or not research was conducted in response to a known or suspected infectious disease outbreak, observed animal morbidity or mortality, etc.
#' @param archival Logical. Whether samples were from an archival source (e.g., museum collections, biobanks).
#' @param num_creators Integer. Number of creators for a work.
#' @param num_titles Integer. Number of titles for a work.
#' @param identifier String. A unique string that identifies a resource. Should be a DOI
#' @param identifier_type String. Should be DOI
#' @param num_subjects Integer. Number of subjects. Subject, keyword, classification code, or key phrase describing the resource
#' @param publication_year String. Year when work was published
#' @param rights String. Use one of the rights identifiers found here https://spdx.org/licenses/
#' @param language String. The primary language of the resource.
#' @param num_descriptions Integer. Number of descriptions to add to the csv. All additional information that does not fit in any of the other categories. May be used for technical information or detailed information associated with a scientific instrument
#' @param num_fundingReferences Integer. Number of funders to add to the csv. Name and other identifying information of a funding provider
#' @param num_related_identifiers Integer. Number of other works you would like to link to.
#' @param write_output Logical. Should the file be written?
#'
#' @returns data.frame
#' @export
#'
#' @examples
#'
#' generate_metadata_csv(file_path = "test.csv",
#' event_based = TRUE,
#' archival = FALSE,
#' num_creators = 10,
#' num_titles = 1,
#' identifier = "https://doi.org/10.1080/example.doi",
#' identifier_type = "doi",
#' num_subjects = 5,
#' publication_year = "2025",
#' rights = "cc-by",
#' language = "en",
#' num_descriptions = 1,
#' num_fundingReferences = 4,
#' num_related_identifiers= 5,
#' write_output = FALSE) # change to TRUE to write the csv
#'
generate_metadata_csv <- function( file_path,
                                   event_based,
                                   archival,
                                   num_creators,
                                   num_titles,
                                   identifier,
                                   identifier_type,
                                   num_subjects,
                                   publication_year,
                                   rights,
                                   language,
                                   num_descriptions,
                                   num_fundingReferences,
                                   num_related_identifiers,
                                   write_output = TRUE

){

  assertthat::assert_that(fs::path_ext(path = file_path) == "csv",msg = "File must be csv")
  assertthat::assert_that(assertthat::is.scalar(event_based) & is.logical(event_based), msg = "event_based must be logical and scalar.")
  assertthat::assert_that(assertthat::is.scalar(archival) & is.logical(archival), msg = "archival must be logical and scalar.")
  assertthat::assert_that(assertthat::is.count(num_creators), msg = "num_creators must be a scalar positive integer")
  assertthat::assert_that(assertthat::is.count(num_titles), msg = "num_titles must be a scalar positive integer")
  assertthat::assert_that(assertthat::is.string(identifier), msg = "identifier must be a scalar string")
  assertthat::assert_that(assertthat::is.string(identifier_type), msg = "identifier_type must be a scalar string")
  assertthat::assert_that(assertthat::is.count(num_subjects), msg = "num_subjects must be a scalar positive integer")
  assertthat::assert_that(assertthat::is.string(publication_year), msg = "publication_year must be a scalar string")
  assertthat::assert_that(assertthat::is.string(rights), msg = "rights must be a scalar string")
  assertthat::assert_that(assertthat::is.string(language), msg = "language must be a scalar string")
  assertthat::assert_that(assertthat::is.count(num_descriptions), msg = "num_descriptions must be a scalar positive integer")
  assertthat::assert_that(assertthat::is.count(num_fundingReferences), msg = "num_fundingReferences must be a scalar positive integer")
  assertthat::assert_that(assertthat::is.count(num_related_identifiers), msg = "num_related_identifiers must be a scalar positive integer")


  df <- data.frame(Group = "", Variable = "", Value = "")

  ## need to make a dataframe with varying levels of completeness

  methdology_df <- data.frame(Group = c("Methodology",""),
                           Variable = c("Event Based","Archival"),
                           Value = c(event_based,archival))

  creators_df <- generate_repeat_dfs(num_groups = num_creators,
                                  group_prefix = "Creators",
                                  group_variables =  "Name,Given Name,Family Name,Name Identifier,Affiliation,Affiliation Identifier")

  titles_df <- generate_repeat_dfs(num_groups = num_titles,
                                group_prefix = "Titles",
                                group_variables = "Title" )

  identifier_df <- data.frame(Group = c("Identifier",""),
                           Variable = c("Identifier","Identifier Type"),
                           Value = c(identifier,identifier_type))

  subjects_df <- generate_repeat_dfs(num_groups = num_subjects,
                                  group_prefix = "Subjects",
                                  group_variables = "Subject")

  publication_year_df <- data.frame(Group = c("Publication Year"),
                                    Variable = c("Publication Year"),
                                    Value = c(publication_year))

  rights_df <- data.frame(Group = c("Rights"),
                          Variable = c("Rights"),
                          Value = c(rights))

  language_df <- data.frame(Group = c("Language"),
                            Variable = c("Language"),
                            Value = c(language))

  description_df <- generate_repeat_dfs(num_groups = num_descriptions,
                                        group_prefix = "Descriptions",
                                        group_variables = "Description,Description Type")

  funders_df <- generate_repeat_dfs(num_groups = num_fundingReferences,
                                    group_prefix = "Funding References",
                                    group_variables = "Funder Name,Funder Identifier,Award Number,Award URI,Award Title" )

  related_ids_df <- generate_repeat_dfs(num_groups = num_related_identifiers,
                                        group_prefix = "Related Identifiers",
                                        group_variables = "Related Identifier,Related Identifier Type,Relation Type"
                                        )

  df_out <- rbind(methdology_df,creators_df,titles_df,identifier_df,subjects_df,publication_year_df,rights_df,language_df,description_df,funders_df,related_ids_df)

  if(write_output){
    readr::write_csv(x = df_out,file = file_path)
  }


  return(df_out)
}

#' generate_repeat_dfs
#'
#' @param num_groups Numeric. Number of groups
#' @param group_prefix Character. A group name
#' @param group_variables Character. A comma separated scalar string of variables.
#'
#' @returns data frame. Structured appropriately for the metadata csv.
#' @export
#'
#' @examples
#'
#' related_ids_df <- generate_repeat_dfs(num_groups = 5,
#' group_prefix = "Related Identifiers",
#' group_variables = "Related Identifier,Related Identifier Type,Relation Type")
#'
generate_repeat_dfs <- function(num_groups,
                                group_prefix,
                                group_variables){

  # get group variables
  group_variables_split <- stringr::str_split(group_variables,",") |>
    unlist()
  # map over number of groups
  purrr::map_df(1:num_groups,function(x){
    group_name <- sprintf("%s %s",group_prefix,x)
    Group <- c(group_name, rep("",(length(group_variables_split)-1)))
    df_out <- data.frame(Group = Group, Variable = group_variables_split, Value = "")
    return(df_out)
  })
}
