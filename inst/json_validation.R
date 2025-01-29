library(jsonlite)
library(jsonvalidate)

schema <- "inst/extdata/wdds_schema/wdds_schema.json"
file.exists(schema)

validator <- jsonvalidate::json_validator(schema,engine = "ajv")

# out <- validator(json = "inst/title.json",verbose = TRUE)
# out

out_full <- validator(json = "inst/full_example.json",verbose = TRUE)
out_full

out_min <- validator(json = "inst/minimal_example.json",verbose = TRUE)
out_min


