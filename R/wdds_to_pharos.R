#' WDDS to PHAROS metadata mapping
#'
#' A table that maps variables between WDDS and the PHAROS data standard (11 September 2025).
#' Will be deprecated once PHARSO and wdds are aligned.
#'
#' @family Data
#' @source <https://pharos.viralemergence.org/>
"wdds_to_pharos_map"


#' Convert WDDS data to PHAROS data
#'
#' As of 11 September 2025, WDDS and the PHAROS data model are not fully aligned.
#' This function converts data that conforms to WDDS into the PHAROS data model.
#' See `wdds_to_pharos_map` for the data model crosswalk.
#'
#' @param wdds_disease_data Data frame. A Disease Data set that conforms to
#' the wdds data standard.
#'
#' @family Standards Mapping
#' @returns Data frame. A tabular data set that conforms to the PHAROS data model.
#' @export
#'
#' @examples
#'
#' wdds_to_pharos(wdds_disease_data = wddsWizard::minimal_disease_data)
#'
wdds_to_pharos <- function(wdds_disease_data){

  assertthat::assert_that(is.data.frame(wdds_disease_data),msg = "Must be a dataframe")
  # subset to the wdds columns used in the dataset
  wdds_pharos_subset <- wdds_to_pharos_map[which(wdds_to_pharos_map$wdds %in% names(wdds_disease_data)),]

  cols_to_keep <- wdds_pharos_subset |>
    dplyr::filter(!is.na(pharos))

  # subset the disease data to the appropriate columns
  disease_data_pharos_cols <- wdds_disease_data[cols_to_keep$wdds]

  # rename columns and convert to character
  disease_data_pharos <- disease_data_pharos_cols %>%
    dplyr::rename_with(~cols_to_keep$pharos, dplyr::all_of(cols_to_keep$wdds)) |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.character))

  # replace NA with blanks
  disease_data_pharos_no_nas <- purrr::map_df(disease_data_pharos, \(x){
    tidyr::replace_na(x,"")
  })

  return(disease_data_pharos_no_nas)
}
