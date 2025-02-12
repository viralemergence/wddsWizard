## code to prepare `schema_required_fields` dataset goes here

schema <- jsonlite::read_json(path = here::here("inst/extdata/wdds_schema/wdds_schema.json"))

required_fields <- schema$required

schema_required_fields <- unlist(required_fields)

usethis::use_data(schema_required_fields, overwrite = TRUE)
