## creates a package specific env
the <- new.env(parent = emptyenv())
the$Group <- ""
the$entity_id <- ""
the$Value <- ""
the$Variable <- ""
the$eventBased <- ""
the$archival <- ""

# for tracking schema when making docs
the$current_schema_path <- here::here("inst/extdata/wdds_schema/wdds_schema.json")
the$current_schema_dir <- fs::path_dir(the$current_schema_path)
the$current_sub_schema_dir <- here::here("inst/extdata/wdds_schema/schemas/")
the$wdds_version <- "latest"


here_curl <- function() {
  here::here("R/aaa.R")
  R6::is.R6()
}
