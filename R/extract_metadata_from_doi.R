#' Extract Project Metadata from DOI
#'
#' Some works are explicitly connected to a publication and the metadata for that publication are fairly complete.
#' Instead of re-writing the metadata, it would be better to extract it and transform it.
#'
#' @param doi String. DOI for a published work
#' @param file_path String. Where should the output be written?
#' @param write_output Logical. Should the output be written to a file?
#'
#' @returns data frame. A data frame structured in the same way as the metadata template csv.
#' @export
#'
#' @examples
extract_metadata_from_doi <- function(doi, file_path, write_output = TRUE){
  if(!curl::has_internet()){
    rlang::abort("An internet connection is required to extract metadata")
  }
  # make sure DOI is properly formatted
  doi <- trimws(doi,"both")

  out <- extract_metadata_oa(doi = doi)
  # extract_metadata_zenodo(doi = doi)

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
#' @export
#'
#' @examples
extract_metadata_oa<-function(doi){

  # doi.org/10.1038/s41597-025-05332-x
  oa_url <- sprintf("https://api.openalex.org/works/%s",doi)

  oa_json <- jsonlite::fromJSON(txt = oa_url)
  oa_json$authorships$affiliations

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
    dplyr::mutate("Given Name" = stringr::str_remove(.data$Name, pattern = `Family Name`))

  # get identifier
  creator_df$`Name Identifier` <- creators$author$orcid

  # get affiliation string and identifier

  aff_df <- creators$affiliations |>
    purrr::map_df(function(x){
       raw_affiliation <- x$raw_affiliation_string[[1]]

       oa_inst_id <- x$institution_ids[[1]][1] |>
                      fs::path_file()

      oa_inst_api  <- sprintf("https://api.openalex.org/institutions/%s", oa_inst_id)

      oa_inst_list <- jsonlite::fromJSON(oa_inst_api)

      oa_inst_list$ror

      out <- data.frame("Affiliation" = raw_affiliation, "Affiliation Identifier" = oa_inst_list$ror)

      return(out)
    })

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

  # fundingReferences

  "Funder Name	NSF
Funder Identifier	http://dx.doi.org/10.13039/10000fake
Award Number	DBI 2515340
Award URI	https://www.viralemergence.org/grants
Award Title	Verena Fellow-in-Residence Award"

  funder_references_tidy <- oa_json$grants |>
    dplyr::mutate(oa_funder_id = fs::path_file(funder)) |>
    dplyr::mutate(oa_funder_api = sprintf("https://api.openalex.org/funders/%s", oa_funder_id)) |>
    dplyr::mutate(funder_identifier = purrr::map_chr(.data$oa_funder_api, function(x){
      funder_json <- jsonlite::fromJSON(x)
      funder_ids <- funder_json$ids
      #use one of ror, crossref doi, or openalex id
      ids_ordered <- c("ror","doi","wikidata","openalex")
      preferred_id <- which(ids_ordered %in% names(funder_ids))[1]
      funder_ids[ids_ordered[preferred_id]][[1]]
    })
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

  out <- rbind(creator_df_expanded,
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


expand_tidy_dfs <- function(tidy_df,group_prefix){

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

make_simple_df <- function(property,value){
  out <- data.frame(Group = property,Variable = property, Value=  value)
  return(out)
}
