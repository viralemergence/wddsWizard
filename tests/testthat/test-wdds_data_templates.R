test_that("wdds_data_templates works", {

  expect_no_failure(
    wdds_data_templates()
  )

  expect_no_failure(
    wdds_data_templates(version = "v_1_0_1")
  )

  expect_no_failure(
    wdds_data_templates(version = "v_1_0_2",file = "disease_data_template.csv")
  )

})

test_that("wdds_data_templates fails if version is not character or NULL", {

  expect_error(wdds_data_templates(version = FALSE))

})


test_that("wdds_data_templates fails if file is not character or NULL", {

  expect_error(wdds_data_templates(file = TRUE))

})
