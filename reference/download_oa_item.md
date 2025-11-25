# Rate limited download of OA items

Checks if file exists in a directory, downloads the file if its not
found. Sleeps for a given amount of time to respect rate limits on
openalex servers.

## Usage

``` r
download_oa_item(entity, oa_id, dir_temp = tempdir(), sleep_time = 1)
```

## Arguments

- entity:

  Character. What kind of openalex item is it?

- oa_id:

  Character. ID from openalex

- dir_temp:

  Character. path to directory where jons is stored.

- sleep_time:

  Numeric. Seconds of sleep.

## Value

Character. File path to json file

## See also

Other Project Metadata:
[`expand_tidy_dfs()`](https://viralemergence.github.io/wddsWizard/reference/expand_tidy_dfs.md),
[`extract_metadata_from_doi()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_from_doi.md),
[`extract_metadata_oa()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_oa.md),
[`generate_metadata_csv()`](https://viralemergence.github.io/wddsWizard/reference/generate_metadata_csv.md),
[`generate_repeat_dfs()`](https://viralemergence.github.io/wddsWizard/reference/generate_repeat_dfs.md),
[`make_simple_df()`](https://viralemergence.github.io/wddsWizard/reference/make_simple_df.md)
