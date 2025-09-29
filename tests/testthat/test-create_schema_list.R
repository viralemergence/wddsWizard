test_that("create_schema_list works", {


  json_file <- wdds_json(version = "latest",file ="wdds_schema.json")

  schema_modified <- schema_obj$new(schema_path = json_file, wdds_version = "latest")

  expect_no_failure(schema_modified$create_schema_list())
})


test_that("create_schema_list fails if not a file", {
  expect_error( schema_obj$new(schema_path = 42, wdds_version = "latest"))
})
