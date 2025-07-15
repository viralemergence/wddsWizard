test_that("wdds_example_data works", {

  expect_no_failure(
    wdds_example_data()
    )

  expect_no_failure(
    wdds_example_data(version = "v_1_0_1")
  )

  expect_no_failure(
    wdds_example_data(version = "v_1_0_2",file = "Becker_demo_dataset.xlsx")
  )

})

test_that("wdds_example_data fails if version is not character or NULL", {

  expect_error(wdds_example_data(version = FALSE))

})


test_that("wdds_example_data fails if file is not character or NULL", {

  expect_error(wdds_example_data(file = TRUE))

})
