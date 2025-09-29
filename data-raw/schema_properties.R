schema_latest <- schema_obj$new(schema_path = "inst/extdata/wdds_schema/wdds_schema.json", wdds_version = "latest")

schema_list_latest <- schema_latest$create_schema_list()


schema_properties <- schema_list_latest |>
  purrr::list_rbind() |>
  dplyr::distinct_all() |>
  dplyr::mutate(
    is_array = dplyr::case_when(
      stringr::str_detect(type, pattern = "array") ~ TRUE,
      TRUE ~ FALSE
    ),
    is_object = dplyr::case_when(
      stringr::str_detect(type, pattern = "object") ~ TRUE,
      TRUE ~ FALSE
    )
  )

usethis::use_data(schema_properties, overwrite = TRUE)
