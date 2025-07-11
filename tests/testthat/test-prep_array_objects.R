test_that("prep_array_objects works", {

  x <- list(tibble::tibble(age = 1,group = letters[1]),
            tibble::tibble(age = 2,group = letters[2]))

  expect_no_failure(
    prep_array_objects(x)
    )
})

test_that("prep_array_objects fails with multi row tibbles", {

  x <- list(tibble::tibble(age = 1:2,group = letters[1:2]),
            tibble::tibble(age = 2,group = letters[2]))

  expect_error(
    prep_array_objects(x)
  )
})

test_that("prep_array_objects fails with non-list", {
  expect_error(prep_array_objects("hello"))
})
