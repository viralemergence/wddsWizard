## code to prepare `spdx_licenses` dataset goes here

spdx_full <- jsonlite::fromJSON(txt = "inst/extdata/metadata_maps/spdx_licenses.json")
spdx_licenses <- spdx_full$licenses
usethis::use_data(spdx_licenses, overwrite = TRUE)
