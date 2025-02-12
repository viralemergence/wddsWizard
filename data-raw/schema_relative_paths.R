
user_schema = '{
  "$schema": "http://json-schema.org/draft-07/schema",
  "type": "object",
  "required": ["address"],
  "properties": {
    "address": {
      "$ref": "sub/address.json"
    }
  }
}'

city_schema <- '{
  "$schema": "http://json-schema.org/draft-07/schema",
  "type": "string",
  "enum": ["Firenze"]
}'
address_schema <- '{
  "$schema": "http://json-schema.org/draft-07/schema",
  "type":"object",
  "properties": {
    "city": { "$ref": "city.json" }
  }
}'

json <- '{
  "address": {
    "city": "Firenze"
  }
}'


path <- tempfile()
subdir <- file.path(path, "sub")
dir.create(subdir, showWarnings = FALSE, recursive = TRUE)
city_path <- file.path(subdir, "city.json")
address_path <- file.path(subdir, "address.json")
user_path <- file.path(path, "schema.json")
writeLines(city_schema, city_path)
writeLines(address_schema, address_path)
writeLines(user_schema, user_path)



jsonvalidate::json_validate(json, user_path, engine = "ajv")
