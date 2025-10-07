#' Extract Project Metadata from DOI
#'
#' Some works are explicitly connected to a publication and the metadata for that publication are fairly complete.
#' Instead of re-writing the metadata, it would be better to extract it and transform it.
#'
#' @param doi String. DOI for a published work
#' @param file_path String. Where should the output be written?
#' @param write_output Logical. Should the output be written to a file?
#' @family Project Metadata
#'
#' @returns data frame. A data frame structured in the same way as the metadata template csv.
#' @export
#'
#' @examples
#'
#' doi <-"doi.org/10.1038/s41597-025-05332-x"
#' extract_metadata_from_doi(doi = doi,write_output=FALSE)
#'
extract_metadata_from_doi <- function(doi, file_path, write_output = TRUE){
  if(!curl::has_internet()){
    rlang::abort("An internet connection is required to extract metadata")
  }

  assertthat::assert_that(assertthat::is.string(doi),msg = "doi must be a non-vector string")

  assertthat::assert_that(assertthat::is.scalar(write_output)&is.logical(write_output),msg = "write_output must be logical and scalar")

  # make sure DOI is properly formatted
  doi <- trimws(doi,"both")

  out <- extract_metadata_oa(doi = doi)
  # extract_metadata_zenodo(doi = doi)

  if(write_output){
    assertthat::assert_that(assertthat::is.string(file_path),msg = "file_path must be a non-vector string")
    readr::write_csv(x = out,file = file_path)
  }

  return(out)
}

#' Extract Metadata from Open Alex record
#'
#'  Uses the DOI for a work to extract metadata from OpenAlex - https://openalex.org/.
#'  The OpenAlex data model does not included some fields that are part
#'  of the wdds project metadata  related identifiers.
#'
#'  Carefully review and edit the metadata produced.
#'
#'  We recommend writing the metadata to a csv, editing the csv, then
#'  processing it as demonstrated in the project metadata tutorial.
#'
#'
#' @param doi Character. A digital object identifier for a published work.
#'
#' @returns data frame. A data frame structured in the same way as the metadata template CSV.
#' @family Project Metadata
#' @export
#'
#' @examples
#'
#' doi <- "doi.org/10.1038/s41597-025-05332-x"
#' extract_metadata_oa(doi = doi)
#'
extract_metadata_oa<-function(doi){

  assertthat::assert_that(assertthat::is.string(doi),msg = "doi must be a non-vector string")
  cli::cli_alert("Starting now, at {Sys.time()}")

  work_json<- download_oa_item(oa_id = doi, entity = "works",sleep_time = 0 )

  oa_json <- jsonlite::fromJSON(txt = work_json)

  # Name	Jane Doe
  # Given Name	Jane
  # Family Name	Doe
  # Name Identifier	https://orcid.org/0000-0003-fake-1111
  # Affiliation	Department of Biology, State University
  # Affiliation Identifier	https://ror.org/02aqsfake

  ## get creators

  creators <- oa_json$authorships

  # get name

  creator_df <- data.frame("Name" = creators$raw_author_name)
  creator_df <- creator_df |>
    dplyr::mutate("Family Name" = stringr::str_split_i(.data$Name, pattern = " ", -1)) |>
    dplyr::mutate("Given Name" = stringr::str_remove(.data$Name, pattern = .data$`Family Name`))

  # get identifier
  creator_df$`Name Identifier` <- creators$author$orcid

  # get affiliation string and identifier
  aff_df <- creators$affiliations |>
    purrr::map_df(function(x){

      raw_affiliation <- x$raw_affiliation_string[[1]]

      oa_inst_id <- x$institution_ids[[1]][1] |>
        fs::path_file()

      inst_json <- download_oa_item(oa_id = oa_inst_id,entity = "institutions")

      oa_inst_list <- jsonlite::fromJSON(txt = inst_json)

      out <- data.frame("Affiliation" = raw_affiliation, "Affiliation Identifier" = oa_inst_list$ror)

      # rate limiting downloads

      return(out)
    }, .progress = "Getting Affiliations")

  creator_df_tidy <- cbind(creator_df,aff_df) |>
    dplyr::rename("Affiliation Identifier" = .data$Affiliation.Identifier)

  # reshape to template form
  creator_df_expanded <- expand_tidy_dfs(creator_df_tidy, group_prefix = "Creators")

  # titles
  title_df_expanded  <-  data.frame(title = oa_json$title) |>
    expand_tidy_dfs(group_prefix = "Titles")

  # publicationYear
  publicationYear_df <- make_simple_df(property = "publicationYear",value=  oa_json$publication_year)
  # language
  language_df <- make_simple_df(property = "language", value = oa_json$language)
  # description
  description_df <- data.frame(Description = "FILL ME IN","Description Type" = "abstract",check.names = FALSE) |>
    expand_tidy_dfs(group_prefix = "Descriptions")

  # methodology

  methodology_df <- data.frame(Group = c("Methodology",""),Variable = c("Event Based","Archival"), Value = FALSE)

  # fundingReferences

  "Funder Name	NSF
Funder Identifier	http://dx.doi.org/10.13039/10000fake
Award Number	DBI 2515340
Award URI	https://www.viralemergence.org/grants
Award Title	Verena Fellow-in-Residence Award"

  funder_references_tidy <- oa_json$grants |>
    dplyr::mutate(oa_funder_id = fs::path_file(.data$funder)) |>
    dplyr::mutate(funder_identifier = purrr::map_chr(.data$oa_funder_id, function(x){
      funder_file <- download_oa_item(oa_id = x,entity = "funders")

      # rate limiting downloads to 10 per second
      funder_json <- jsonlite::fromJSON(funder_file)
      funder_ids <- funder_json$ids
      #use one of ror, crossref doi, or openalex id
      ids_ordered <- c("ror","doi","wikidata","openalex")
      preferred_id <- which(ids_ordered %in% names(funder_ids))[1]
      funder_ids[ids_ordered[preferred_id]][[1]]
    }, .progress = "Getting Funder Info")
    ) |>
    dplyr::select(dplyr::all_of(c("funder_display_name","funder_identifier","award_id"))) |>
    dplyr::rename("Funder Name" = "funder_display_name",
                  "Funder Identifier" = "funder_identifier",
                  "Award Number" = "award_id"
    ) |>
    dplyr::mutate(
      "Award URI" = "",
      "Award ID" = ""
    )

  funder_references_df <- expand_tidy_dfs(funder_references_tidy, group_prefix = "Funding References")


  # subjects

  subjects_df <- data.frame(Subject = oa_json$keywords$display_name) |>
    expand_tidy_dfs(group_prefix = 'Subjects')

  # Related Identifiers

  related_identifiers_tidy  <- data.frame("Related Identifier" = "A valid Identifier like a DOI",
                                          "Related Identifier Type" = "see accepted values here https://datacite-metadata-schema.readthedocs.io/en/4.5/appendices/appendix-1/relatedIdentifierType/#relatedidentifiertype",
                                          "Relation Type" = "see accepted values here: https://datacite-metadata-schema.readthedocs.io/en/4.5/appendices/appendix-1/relationType/#relationtype",check.names = FALSE )

  related_identifiers_df <- related_identifiers_tidy |>
    expand_tidy_dfs(group_prefix = "Related Identifiers")


  # rbind data frames

  out <- rbind(methodology_df,
               creator_df_expanded,
               title_df_expanded,
               publicationYear_df,
               language_df,
               description_df,
               funder_references_df,
               subjects_df,
               related_identifiers_df
  )

  return(out)

}


#' Expand tidy dataframes to project metadata template format
#'
#' Creates a JSON-like structure in the csv that can be processed using
#' established workflows in this package.
#'
#' @param tidy_df data frame. Each row corresponds to a complete entry.
#' @param group_prefix character. A repeatable metadata property in the project
#'  metadata section of WDDS. See https://viralemergence.github.io/wddsWizard/articles/schema_overview.html#project_metadata
#'
#' @family Project Metadata
#' @returns Data frame. The data frame contains the fields Group, Variable, and Value.
#' @export
#'
#' @examples
#'
#'# a nice tidy dataset
#' creators_tidy <- data.frame("Name" = paste(letters[1:10],LETTERS[1:10]),
#'          "Given Name" = letters[1:10],
#'          "Family Name" = LETTERS[1:10],
#'          "Name Identifier" = sample(1:100,10,FALSE),
#'          "Affiliation" = letters[11:20],
#'          "Affiliation Identifier" = 11:20,
#'          check.names =FALSE)
#'
#'# an expanded dataset that matches the template format.
#' creators_tidy |>
#'  expand_tidy_dfs(group_prefix = "Creators")
#'
#'
#'
expand_tidy_dfs <- function(tidy_df,group_prefix){

  assertthat::assert_that(assertthat::is.string(group_prefix),msg = "group_prefix must be character and length 1")
  # number of groups
  num_groups <- nrow(tidy_df)

  # group of variables
  group_variables <- names(tidy_df)

  df_out <- df_out <- data.frame(Group = character(0),
                                 Variable = character(0),
                                 Value = character(0))

  for(i in 1:num_groups){
    values <- tidy_df[i,] |> unlist()
    names(values) <- NULL
    group_name <- sprintf("%s %s",group_prefix,i)
    Group <- c(group_name, rep("",(length(group_variables)-1)))
    df_i <- data.frame(Group = Group, Variable = group_variables, Value = values)
    df_out <- rbind(df_out, df_i)
  }

  return(df_out)
}

#' A convenience function for making non-repeating items
#'
#' @param property string. Metadata group and variable name
#' @param value A value for that property.
#'
#' @family Project Metadata
#'
#' @returns data frame. A data frame that conforms to non-repeatable structure in template.
#' @export
#'
#' @examples
#' language_df <- make_simple_df(property = "language", value = "fr")
#'
make_simple_df <- function(property,value){
  assertthat::assert_that(assertthat::is.string(property),msg = "property must be length 1 and type character")

  assertthat::assert_that(assertthat::is.scalar(value),msg = "value must be length 1")

  out <- data.frame(Group = property,Variable = property, Value=  value)
  return(out)
}

#' Rate limited download of OA items
#'
#' Checks if file exists in a directory, downloads the file if its not found.
#' Sleeps for a given amount of time to respect rate limits on openalex servers.
#'
#' @param entity Character. What kind of openalex item is it?
#' @param oa_id Character. ID from openalex
#' @param dir_temp Character. path to directory where jons is stored.
#' @param sleep_time Numeric. Seconds of sleep.
#'
#' @returns Character. File path to json file
#' @family Project Metadata
download_oa_item <- function(entity,oa_id, dir_temp = tempdir(),sleep_time = 1){

  entities <- c("works","institutions","funders","authors","sources","topics"
  ,"publishers")

  msg <- sprintf("Entity must be one of:\n%s", paste(entities,collapse = "\n"))

  assertthat::assert_that(entity %in% entities,msg = msg)
  assertthat::assert_that( assertthat::is.string(oa_id),msg = "oa_id must be character")
  assertthat::assert_that(fs::dir_exists(dir_temp), msg = "dir_temp must exist")
  assertthat::assert_that(assertthat::is.number(sleep_time), msg = "sleep_time must be numeric and scalar")

  ## normalize the inputs so it handles dois appropriately
  file_id <- rlang::hash(x = oa_id)

  oa_json <- sprintf("%s/%s.json",dir_temp,file_id)
  oa_api  <- sprintf("https://api.openalex.org/%s/%s",entity, oa_id)



  # if the file doesnt exist, get it
  if(!fs::file_exists(oa_json)){
    curl::curl_download(url = oa_api,destfile = oa_json)
    Sys.sleep(sleep_time)
  }

  return(oa_json)

}


