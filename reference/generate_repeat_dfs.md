# generate_repeat_dfs

generate_repeat_dfs

## Usage

``` r
generate_repeat_dfs(num_groups, group_prefix, group_variables)
```

## Arguments

- num_groups:

  Numeric. Number of groups

- group_prefix:

  Character. A group name

- group_variables:

  Character. A comma separated scalar string of variables.

## Value

data frame. Structured appropriately for the metadata csv.

## See also

Other Project Metadata:
[`download_oa_item()`](https://viralemergence.github.io/wddsWizard/reference/download_oa_item.md),
[`expand_tidy_dfs()`](https://viralemergence.github.io/wddsWizard/reference/expand_tidy_dfs.md),
[`extract_metadata_from_doi()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_from_doi.md),
[`extract_metadata_oa()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_oa.md),
[`generate_metadata_csv()`](https://viralemergence.github.io/wddsWizard/reference/generate_metadata_csv.md),
[`make_simple_df()`](https://viralemergence.github.io/wddsWizard/reference/make_simple_df.md)

## Examples

``` r
related_ids_df <- generate_repeat_dfs(num_groups = 5,
group_prefix = "Related Identifiers",
group_variables = "Related Identifier,Related Identifier Type,Relation Type")
```
