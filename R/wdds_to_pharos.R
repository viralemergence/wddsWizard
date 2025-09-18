#' WDDS to PHAROS metadata mapping
#'
#' A table that maps variables between WDDS and the PHAROS data standard (11 September 2025).
#' Will be deprecated once PHARSO and wdds are aligned.
#'
#' @family Data
#' @source <https://pharos.viralemergence.org/>
"wdds_to_pharos_map"


#' Convert WDDS disease data to PHAROS data
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
#' # data must be written to CSV then uploaded to PHAROS
#'
wdds_to_pharos <- function(wdds_disease_data){

  wdds_to_pharos_map<- wddsWizard::wdds_to_pharos_map

  assertthat::assert_that(is.data.frame(wdds_disease_data),msg = "Must be a dataframe")
  # subset to the wdds columns used in the dataset
  wdds_pharos_subset <- wdds_to_pharos_map[which(wdds_to_pharos_map$wdds %in% names(wdds_disease_data)),]

  cols_to_keep <- wdds_pharos_subset |>
    dplyr::filter(!is.na(.data$pharos))

  # subset the disease data to the appropriate columns
  disease_data_pharos_cols <- wdds_disease_data[cols_to_keep$wdds]

  # rename columns
  disease_data_pharos <- disease_data_pharos_cols |>
    dplyr::rename_with(~cols_to_keep$pharos, dplyr::all_of(cols_to_keep$wdds))

  # replace NA with blanks
  disease_data_pharos_no_nas <- na_to_blank(disease_data_pharos)

  rlang::inform(message = "`sampleCollectionMethod` does not map perfectly to `Collection method or tissue`. Please review those entries.")

  if("Dead or alive" %in% names(disease_data_pharos_no_nas)){
    rlang::inform(message = "`liveCapture` does not map perfectly to `Dead or alive`. Please review those entries.")
  }


  return(disease_data_pharos_no_nas)
}


#' Convert NA's to blanks
#'
#' Converts all columns to character then converts all NA's to blanks.
#'
#'
#' @param df data frame. A data frame where NAs should be coverted to blanks. Cannot be a tibble with nested columns.
#'
#' @returns data frame. All columns will be character and all NA's will be replaced with "".
#' @export
#'
#' @examples
#'
#' data.frame(a = 1:10, b = c(1:9,NA)) |>
#'   na_to_blank()
#'
na_to_blank <- function(df){

  df_char <- df |>
  dplyr::mutate(dplyr::across(dplyr::everything(), as.character))

  # replace NA with blanks
  out <- purrr::map_df(df_char, \(x){
    tidyr::replace_na(x,"")
  })

  return(out)
}
