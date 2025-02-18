## code to prepare `data_required_fields` dataset goes here

data_schema <- jsonlite::read_json(path = here::here("inst/extdata/wdds_schema/schemas/project_metadata.json"))
required_data_fields <- data_schema$required

project_metadata_required_fields<- unlist(required_data_fields)

usethis::use_data(project_metadata_required_fields, overwrite = TRUE)
