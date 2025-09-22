test_that("wdds_to_dcmi works", {

    project_metadata <- wdds_example_data(version = "latest",
                                      file = "example_project_metadata.csv")|>
      read.csv()

  test_pmd <- project_metadata |>
    prep_from_metadata_template(json_prep = FALSE)

  test_pmd$rights$rights <- "CC0-1.0"

  expect_no_failure(wdds_to_dcmi(metadata_to_translate = test_pmd,
                                 translation_map =  wddsWizard::wdds_to_dcmi_map))
})




test_that("wdds_to_dcmi fails", {

  expect_error(wdds_to_dcmi(metadata_to_translate = c("hello"),
                                 translation_map =  wddsWizard::wdds_to_dcmi_map))
})
