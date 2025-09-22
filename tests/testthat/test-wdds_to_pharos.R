test_that("wdds_to_pharos works", {

  df <- wddsWizard::minimal_disease_data

  expect_no_failure(wdds_to_pharos(wdds_disease_data = df))

  })


test_that("wdds_to_pharos fails", {

  wdds_list <- as.list(wddsWizard::minimal_disease_data)

  expect_error(wdds_to_pharos(wdds_disease_data = wdds_list))

})
