# Get schema references

Parses \$ref calls in a schema. Can retrieve internal
('"\$ref":"#/definitions/someDef") or external references
('"\$ref":"schemas/datacite/datacite.json"').

## Usage

``` r
get_ref(x, schema_dir)
```

## Arguments

- x:

  List. Must have property "\$ref"

- schema_dir:

  Character. Directory for the current schema.

## Value

List or Character. Character is only returned if an entire schema is
referenced.

## Details

For external references, it can handle both pointers and references to
entire schemas. This function navigates between parent and child schemas
by manipulating variables in the package environment `the`.

## See also

Other Schema Docs:
[`create_object_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_object_docs.md),
[`create_schema_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_schema_docs.md),
[`get_required_fields()`](https://viralemergence.github.io/wddsWizard/reference/get_required_fields.md),
[`increase_docs_depth()`](https://viralemergence.github.io/wddsWizard/reference/increase_docs_depth.md),
[`paste_reduce()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce.md),
[`paste_reduce_ul()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce_ul.md)
