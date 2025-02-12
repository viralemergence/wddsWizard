## code to prepare `data_required_fields` dataset goes here

wdds_schema <- jsonlite::read_json(path = here::here("inst/extdata/wdds_schema/wdds_schema.json"))
required_data_fields <- wdds_schema$properties$data$required

data_required_fields<- unlist(required_data_fields)


usethis::use_data(data_required_fields, overwrite = TRUE)
