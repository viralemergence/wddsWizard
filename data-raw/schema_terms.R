## code to prepare `schema_terms` dataset goes here
devtools::load_all()

schema_terms <- create_schema_docs(here::here("inst/extdata/wdds_schema/wdds_schema.json"))

schema_terms <- stringr::str_replace_all(schema_terms, pattern = "- -", replacement = "-")
#
# header_yml <- '---
# title: "deleteme"
# author: "Collin Schwantes"
# date: "`r Sys.Date()`"
# output: html_document
# ---
# '
# paste(header_yml,schema_terms,sep = "\n") |>
#   cat(file = "vignettes/deleteme.Rmd")


schema_terms |>
  cat(file = "vignettes/schema_overview.Rmd", append = TRUE)

# pkgdown::build_site()

usethis::use_data(schema_terms, overwrite = TRUE)
