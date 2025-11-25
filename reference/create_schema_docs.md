# Create Documentation for a schema

Produces nested markdown that documents a schema. This is a recursive
set of function

## Usage

``` r
create_schema_docs(schema_path = the$current_schema_path, sep = "\n")
```

## Arguments

- schema_path:

  Character. Path to a json-schema. Default is the current schema path
  set in the package environment `the`.

- sep:

  Character. separator to be used by
  [`paste_reduce()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce.md).
  Default is `"\n"` to create line breaks.

## Value

character vector of markdown text

## See also

Other Schema Docs:
[`create_object_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_object_docs.md),
[`get_ref()`](https://viralemergence.github.io/wddsWizard/reference/get_ref.md),
[`get_required_fields()`](https://viralemergence.github.io/wddsWizard/reference/get_required_fields.md),
[`increase_docs_depth()`](https://viralemergence.github.io/wddsWizard/reference/increase_docs_depth.md),
[`paste_reduce()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce.md),
[`paste_reduce_ul()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce_ul.md)

## Examples

``` r
if (FALSE) { # \dontrun{
create_schema_docs()
} # }
```
