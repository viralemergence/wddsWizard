## code to prepare `becker_disease_data` dataset goes here
library(dplyr)
library(readxl)
library(janitor)
library(jsonlite)

## read xl
becker_data <- readxl::read_xlsx(path = here::here("inst/extdata/example_data/Becker_demo_dataset.xlsx"))

becker_data_prelim <- janitor::clean_names(becker_data, case = "lower_camel")

becker_disease_data <- becker_data_prelim |>
  dplyr::rename(
    "sampleID" = "sampleId",
    "animalID" = "animalId",
    "collectionMethodAndOrTissue" = "collectionMethod"
  )


usethis::use_data(becker_disease_data, overwrite = TRUE)
