## code to prepare `data_required_fields` dataset goes here

data_schema <- jsonlite::read_json(path = here::here("inst/extdata/wdds_schema/schemas/disease_data.json"))
required_data_fields <- data_schema$required

disease_data_required_fields<- unlist(required_data_fields)

usethis::use_data(disease_data_required_fields, overwrite = TRUE)
