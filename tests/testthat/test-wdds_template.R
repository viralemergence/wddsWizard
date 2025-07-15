test_that("wdds_template works", {
  expect_no_failure(wdds_template())
  expect_no_failure(wdds_template("disease_data_template.csv"))
})


test_that("wdds_template accepts only character or null", {
  expect_error(wdds_template(template_file = 1))
  expect_error(wdds_template(template_file = FALSE))
})
