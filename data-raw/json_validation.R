library(jsonlite)
library(jsonvalidate)

schema <- here::here("inst/extdata/wdds_schema/wdds_schema.json")
file.exists(schema)

validator <- jsonvalidate::json_validator(schema, engine = "ajv")


out_min <- validator(json = here::here("inst/extdata/example_data/minimal_example.json"), verbose = TRUE)
out_min

# df <- data.frame("number" = 1:3,"sampleID" = letters[1:3],"missing" = c(TRUE,NA,FALSE))
#
# write.csv(df,file = "inst/simple.csv",row.names = FALSE)
#
# simple_df <- read.csv("inst/simple.csv")
#
# jsonlite::toJSON(simple_df,dataframe = "columns")
