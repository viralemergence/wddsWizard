#' WDDS to DCMI metadata mapping
#'
#' A list that maps variables between WDDS and the DCMI data standards.
#'
#'
#' @family Data
#' @source <https://github.com/ropenscilabs/deposits/blob/main/inst/extdata/dc/schema.json>
"wdds_to_dcmi_map"

#' Data frame of SPDX licenses
#'
#' A table with SPDX license metadata. Use spdx_licenses$licenseId when uploading
#' data to Zenodo.
#'
#'
#' @family Data
#' @source <https://github.com/spdx/license-list-data/blob/main/json/licenses.json>
"spdx_licenses"

#' WDDS to the Dublin Core Metadata Initiative
#'
#' Converts WDDS project metadata to Zenodo flavored DCMI metadata.
#'
#' @param metadata_to_translate List. Metadata that conforms to the WDDS data standard but is not prepped for JSON. See `prep_from_metadata_template`
#' @param translation_map List. A list that describes how to translate from WDDS to DCMI.
#'
#' @family Standards Mapping
#' @returns List. Translated metadata with appropriate names.
#' @export
#'
#' @examples
#'
#' project_metadata <- wdds_example_data(version = "latest",
#'                                     file = "example_project_metadata.csv")|>
#'     read.csv()
#'
#' test_pmd <- project_metadata |>
#'   prep_from_metadata_template(json_prep = FALSE)
#'
#' test_pmd$rights$rights <- "CC0-1.0"
#'
#' dcmi_metadata <- wdds_to_dcmi(metadata_to_translate = test_pmd,
#'                               translation_map =  wddsWizard::wdds_to_dcmi_map)
#'
#'
wdds_to_dcmi <- function(metadata_to_translate, translation_map =  wddsWizard::wdds_to_dcmi_map){

  assertthat::assert_that(is.list(metadata_to_translate),msg = "metadata_to_translate must be list")
  assertthat::assert_that(is.list(translation_map),msg = "translation_map must be list")

  #subset map to items in metadata

  translations_subset <- names(translation_map$translations) %in% names(metadata_to_translate)

  translation_map$translations <- translation_map$translations[translations_subset]

  out_names <- purrr::map_chr(translation_map$translations,\(x){
    x$targets
  })

  out <- purrr::imap(translation_map$translations,\(x,idx){
    # print(idx)
    # if(idx == "titles"){
    #   browser()
    # }
    item <- metadata_to_translate[[idx]]

    translate_to_dcmi(item = item, translation_map = x)

  })

  out <- purrr::set_names(out, out_names)

  # verify that license is on approved list
  if("license" %in% names(out)){
    license_check <- out$license %in% wddsWizard::spdx_licenses$licenseId

    if(!license_check){
      potential_matches <- stringr::str_subset( wddsWizard::spdx_licenses$licenseId,pattern = "CC0") |>
        paste(collapse = "\n")

      msg <- sprintf("license - %s - not in wddsWizard::spdx_licenses$licenseId.\n Update the rights property in your data.\n Potential matches: %s", out$license,potential_matches)

      rlang::abort(message = msg)
    }

  }

  return(out)

}

#' translate to dcmi
#'
#' @param item List. Item to be translated.
#' @param translation_map List. Instructions for translating the item
#'
#' @returns List. Item that has been translated to DCMI
#' @export
#'
translate_to_dcmi <- function(item, translation_map){

  assertthat::assert_that(is.list(translation_map)&!is.data.frame(translation_map),msg = "translation_map must be list and not a data frame.")

  if("translations" %in% names(translation_map)) {

    # get consistent depth on items
    if(purrr::pluck_depth(item) < 3){
      item <- list(item)
    }

    item_list <- purrr::map(item,as.list)

    item <- purrr::map(item_list,\(x){
      wdds_to_dcmi(metadata_to_translate = x, translation_map = translation_map)
    })
  }


  if(translation_map$type == "string"){

    if(is.data.frame(item)){
      value <- item |>
        dplyr::pull(!!rlang::sym(translation_map$targets))
    } else{
      value <- item
    }

    # Should an array or object be converted to a string?
    if("flatten" %in% names(translation_map)){
      if(translation_map$flatten){
        value <- unlist(value)
      }
    }

    out <- prep_atomic(value,unbox=FALSE)
    return(out)
  }

  if(translation_map$type == "array_of_objects"){
    # browser()
    # out <- prep_array_objects(item, unbox = FALSE)
    out <- item
    return(out)
  }


  if(translation_map$type == "object"){
     # browser()

    if(translation_map$isArray){
      item_prelim <- unlist(item)
      list_name <- names(item_prelim) |> unique()
      names(item_prelim) <- NULL
      item <- list(item_prelim)
      names(item) <- list_name
    }

    out <- prep_object(item)
    return(out)
  }
}
