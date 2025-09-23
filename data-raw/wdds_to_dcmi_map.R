## code to prepare `wdds_to_dcmi_map` dataset goes here

wdds_to_dcmi_map <- jsonlite::fromJSON(here::here("inst/extdata/metadata_maps/wdds_zenodo_map.json"))
usethis::use_data(wdds_to_dcmi_map, overwrite = TRUE)
