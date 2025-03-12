## code to prepare `wdds_schema` dataset goes here

wdds_schema <- jsonlite::read_json(path = here::here("inst/extdata/wdds_schema/wdds_schema.json"))

usethis::use_data(wdds_schema, overwrite = TRUE)


##
disease_data_schema <- jsonlite::read_json(path = here::here("inst/extdata/wdds_schema/schemas/disease_data.json"))

usethis::use_data(disease_data_schema, overwrite = TRUE)

##
project_metadata_schema <- jsonlite::read_json(path = here::here("inst/extdata/wdds_schema/schemas/project_metadata.json"))

usethis::use_data(project_metadata_schema, overwrite = TRUE)
