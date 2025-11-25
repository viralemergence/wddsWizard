# A convenience function for making non-repeating items

A convenience function for making non-repeating items

## Usage

``` r
make_simple_df(property, value)
```

## Arguments

- property:

  string. Metadata group and variable name

- value:

  A value for that property.

## Value

data frame. A data frame that conforms to non-repeatable structure in
template.

## See also

Other Project Metadata:
[`download_oa_item()`](https://viralemergence.github.io/wddsWizard/reference/download_oa_item.md),
[`expand_tidy_dfs()`](https://viralemergence.github.io/wddsWizard/reference/expand_tidy_dfs.md),
[`extract_metadata_from_doi()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_from_doi.md),
[`extract_metadata_oa()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_oa.md),
[`generate_metadata_csv()`](https://viralemergence.github.io/wddsWizard/reference/generate_metadata_csv.md),
[`generate_repeat_dfs()`](https://viralemergence.github.io/wddsWizard/reference/generate_repeat_dfs.md)

## Examples

``` r
language_df <- make_simple_df(property = "language", value = "fr")
```
