test_that("create_schema_list works", {
  expect_no_failure(create_schema_list())
})


test_that("create_schema_list fails if not a file",{
  expect_error(create_schema_list(schema_path = NULL))
})
