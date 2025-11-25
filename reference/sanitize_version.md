# Sanitize version ids

This function replaces periods with under scores. The different versions
of the data standard are stored in folders with their respective names;
however, having periods in folder names can cause problems on certain
operating systems and makes it more difficult to parse file extensions.

## Usage

``` r
sanitize_version(version)
```

## Arguments

- version:

  Character. Version identifier.

## Value

Character. Version identifier with no periods.

## See also

Other WDDS deposit:
[`batch_download_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/batch_download_deposit_versions.md),
[`download_deposit_version()`](https://viralemergence.github.io/wddsWizard/reference/download_deposit_version.md),
[`list_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/list_deposit_versions.md),
[`set_wdds_version()`](https://viralemergence.github.io/wddsWizard/reference/set_wdds_version.md),
[`wdds_data_templates()`](https://viralemergence.github.io/wddsWizard/reference/wdds_data_templates.md),
[`wdds_example_data()`](https://viralemergence.github.io/wddsWizard/reference/wdds_example_data.md),
[`wdds_json()`](https://viralemergence.github.io/wddsWizard/reference/wdds_json.md)

## Examples

``` r
sanitize_version("v.1.1.0")
#> [1] "v_1_1_0"
```
