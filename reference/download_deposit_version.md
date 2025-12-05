# Download deposit version

Downloads and extracts some version of the deposit. This function is
specific to the structure of the wdds repo.

## Usage

``` r
download_deposit_version(zenodo_id, version, latest_version, dir_path)
```

## Arguments

- zenodo_id:

  String. ID for a Zenodo deposit. Should correspond to the version of a
  deposit.

- version:

  String. Version number/id for the deposit (e.g. v.1.1.1).

- latest_version:

  Logical. Indicates that the work is designated as the latest version.

- dir_path:

  String. Path to directory where the files should be downloaded e.g.
  "inst/extdata/wdds_archive" note no trailing slash on the path.

## Value

String. Path to downloaded version.

## See also

Other WDDS deposit:
[`batch_download_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/batch_download_deposit_versions.md),
[`list_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/list_deposit_versions.md),
[`sanitize_version()`](https://viralemergence.github.io/wddsWizard/reference/sanitize_version.md),
[`set_wdds_version()`](https://viralemergence.github.io/wddsWizard/reference/set_wdds_version.md),
[`wdds_data_templates()`](https://viralemergence.github.io/wddsWizard/reference/wdds_data_templates.md),
[`wdds_example_data()`](https://viralemergence.github.io/wddsWizard/reference/wdds_example_data.md),
[`wdds_json()`](https://viralemergence.github.io/wddsWizard/reference/wdds_json.md)

## Examples

``` r
# list all deposit versions
list_deposit_versions()
#>   zenodo_id version latest_version
#> 1  17717011 v.1.0.5           TRUE
#> 2  17095076 v.1.0.4          FALSE
#> 3  15270582 v.1.0.3          FALSE
#> 4  15257971 v.1.0.2          FALSE
#> 5  15133410 v.1.0.1          FALSE
#> 6  15020050 v.1.0.0          FALSE

# download the deposit

if (FALSE) { # \dontrun{
download_deposit_version("15270582", "v.1.0.3", TRUE, "data")
} # }
```
