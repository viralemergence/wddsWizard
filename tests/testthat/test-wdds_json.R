test_that("wdds_json works", {

  expect_no_failure(wdds_json())

  expect_no_failure(
    wdds_json(version = "v_1_0_1")
    )

  expect_no_failure(
    wdds_json(version = "v_1_0_2",file = "schemas/disease_data.json")
  )

})


test_that("wdds_json fails if version is not character or NULL", {

  expect_error(wdds_json(version = FALSE))

})


test_that("wdds_json fails if file is not character or NULL", {

  expect_error(wdds_json(file = TRUE))

})
