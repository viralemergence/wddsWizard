# Get the required fields

Gets the required fields for an object or schema

## Usage

``` r
get_required_fields(schema_list)
```

## Arguments

- schema_list:

  List from jsonlite::read_json

## Value

character vector of required fields

## See also

Other Schema Docs:
[`create_object_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_object_docs.md),
[`create_schema_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_schema_docs.md),
[`get_ref()`](https://viralemergence.github.io/wddsWizard/reference/get_ref.md),
[`increase_docs_depth()`](https://viralemergence.github.io/wddsWizard/reference/increase_docs_depth.md),
[`paste_reduce()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce.md),
[`paste_reduce_ul()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce_ul.md)

## Examples

``` r
schema_list <- jsonlite::read_json(wdds_json("latest", "schemas/disease_data.json"))
get_required_fields(schema_list)
#> [1] "sampleID"               "latitude"               "longitude"             
#> [4] "sampleCollectionMethod" "hostIdentification"     "detectionTarget"       
#> [7] "detectionMethod"        "detectionOutcome"       "parasiteIdentification"
```
