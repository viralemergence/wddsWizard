# Batch download deposit versions

This is `download_deposit_version` wrapped in a `purr::pmap` call.

## Usage

``` r
batch_download_deposit_versions(df = list_deposit_versions(), dir_path)
```

## Arguments

- df:

  Data frame. Has the same structure as the output of
  [`list_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/list_deposit_versions.md).
  Default is
  [`list_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/list_deposit_versions.md)
  so that it downloads all versions of the deposit.

- dir_path:

  Character. Path to folder where files should be downloaded.

## Value

List of download locations.

## See also

Other WDDS deposit:
[`download_deposit_version()`](https://viralemergence.github.io/wddsWizard/reference/download_deposit_version.md),
[`list_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/list_deposit_versions.md),
[`sanitize_version()`](https://viralemergence.github.io/wddsWizard/reference/sanitize_version.md),
[`set_wdds_version()`](https://viralemergence.github.io/wddsWizard/reference/set_wdds_version.md),
[`wdds_data_templates()`](https://viralemergence.github.io/wddsWizard/reference/wdds_data_templates.md),
[`wdds_example_data()`](https://viralemergence.github.io/wddsWizard/reference/wdds_example_data.md),
[`wdds_json()`](https://viralemergence.github.io/wddsWizard/reference/wdds_json.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# download all versions
batch_download_deposit_versions(dir_path = "data")
} # }
```
