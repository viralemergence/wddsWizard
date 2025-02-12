## code to prepare `wdds_schema` dataset goes here

wdds_schema <- jsonlite::read_json(path = here::here("inst/extdata/wdds_schema/wdds_schema.json"))

usethis::use_data(wdds_schema, overwrite = TRUE)
