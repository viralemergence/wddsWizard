## code to prepare `wdds_to_pharos_map` dataset goes here

wdds_to_pharos_map <- readr::read_csv(file = here::here("inst/extdata/metadata_maps/wdds_pharos_map.csv"),col_types = "c")

usethis::use_data(wdds_to_pharos_map, overwrite = TRUE)
