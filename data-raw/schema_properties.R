
schema_list_whole <- create_schema_list()

schema_properties <- schema_list_whole |>
  purrr::list_rbind() |>
  dplyr::distinct_all() |>
  dplyr::mutate(
    is_array = dplyr::case_when(
      stringr::str_detect(type,pattern = "array") ~ TRUE,
      TRUE ~ FALSE
    ),
    is_object = dplyr::case_when(
      stringr::str_detect(type,pattern = "object") ~ TRUE,
      TRUE ~ FALSE
    )
  )

usethis::use_data(schema_properties, overwrite = TRUE)
