## code to prepare `datacite_schema` dataset goes here

datacite_schema <- here::here("inst/extdata/wdds_schema/schemas/datacite/datacite-v4.5.json") |>
  jsonlite::read_json()

usethis::use_data(datacite_schema, overwrite = TRUE)
