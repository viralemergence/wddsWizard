test_that("translate works", {


  project_metadata <- wdds_example_data(version = "latest",
                                      file = "example_project_metadata.csv")|>
      read.csv()

  test_pmd <- project_metadata |>
    prep_from_metadata_template(json_prep = FALSE)

  test_pmd$rights$rights <- "CC0-1.0"

  item <- test_pmd$rights
  translation_map<- wdds_to_dcmi_map$translations$rights

  expect_no_failure(
    translate_to_dcmi(item, translation_map)
  )

})


test_that("translate fails", {


  project_metadata <- wdds_example_data(version = "latest",
                                        file = "example_project_metadata.csv")|>
    read.csv()

  test_pmd <- project_metadata |>
    prep_from_metadata_template(json_prep = FALSE)

  test_pmd$rights$rights <- "CC0-1.0"

  item <- test_pmd$rights
  translation_map<- wdds_to_dcmi_map$translations$rights

  expect_error(
    translate_to_dcmi(item, as.data.frame(translation_map))
  )

})
