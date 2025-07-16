test_that("list_wdds_templates works", {
  expect_no_failure(list_wdds_templates())
  expect_no_failure(list_wdds_templates("disease_data_template.csv"))
})


test_that("list_wdds_templates accepts only character or null", {
  expect_error(list_wdds_templates(template_file = 1))
  expect_error(list_wdds_templates(template_file = FALSE))
})
