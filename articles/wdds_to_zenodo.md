# WDDS to Zenodo

The Wildlife Disease Data Standard (WDDS) aims to make data Findable
Accessible Interoperable and Re-useable (FAIR). A big part of making
data findable is 1) depositing it in an archive that can be searched and
2) providing metadata to improve discoverability. By depositing data in
a generalist repository like Zenodo, you are placing it into an archive
that is free to access, widely used, searchable and extremely durable.
By using WDDS, your data will be interpretable to others increasing
re-usability.

This vignette will walk through depositing data validated against the
WDDS standard into Zenodo using the [deposits
package](https://github.com/ropenscilabs/deposits) to create an
interoperable [Frictionless data
package](https://datapackage.org/standard/data-package/).

## What is Zenodo?

[Zenodo](https://about.zenodo.org/) is a generalist data repository with
long term support and broad use across scientific disciplines.

Key Features:

1.  Long term funding (50 year funding horizon)
2.  DOI minting and Robust data versioning
3.  Users can upload files as large as 50 gb
4.  Robust metadata that improve discovery
5.  [Well documented API](https://developers.zenodo.org/) for
    programmatic interaction

We like Zenodo because it provides a stable place to deposit data.

### Whats the difference between WDDS project metadata and Zenodo deposit metadata?

The difference between WDDS and Zenodo is that WDDS uses [datacite
terms](https://datacite-metadata-schema.readthedocs.io/en/4.6/) and the
Zenodo API largely uses [DCMI
terms](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/).
This can cause confusion because certain terms are false cognates -
e.g. rights vs license.

### Read in project metadata

``` r
library(wddsWizard)
library(deposits)
```

In this tutorial, we will assume you’ve used the project metadata
template to create your metadata.

``` r
project_metadata <- wdds_example_data(version = "latest", file = "example_project_metadata.csv") |> read.csv()
```

Unlike validating against the WDDS template, we do NOT want to prep the
data for JSON. The `deposits` package will essentially do that for us.

Make sure `json_prep = FALSE`.

``` r
# Do NOT prep the data for json!! The data is stored in a more consistent fashion if don't do the json prep, making it easier to convert to dcmi/zenodo form 
project_metadata_prepped <- prep_from_metadata_template(project_metadata,json_prep = FALSE)

# The DOI is random and will cause problems
# drop the identifier since its not actually related to our data
# If you have a Zenodo issued DOI already for your data it should be fine.
drop_identifier <- which(names(project_metadata_prepped) == "identifier")

project_metadata_prepped <- project_metadata_prepped[-drop_identifier]
```

### Map fields to DCMI

This is done using the `wdds_to_dcmi` function. For the curious, you can
look at the `wdds_to_dcmi_map` dataset or the `wdds_zenodo_map.json`
file included in with the package to see how properties are mapped from
one standard to the other.

``` r

tryCatch(
dcmi_metadata <- wdds_to_dcmi(metadata_to_translate = project_metadata_prepped, translation_map = wdds_to_dcmi_map),
error = function(e){
  print(e)
}
)
#> <error/purrr_error_indexed>
#> Error in `map2()`:
#> ℹ In index: 5.
#> ℹ With name: rights.
#> Caused by error in `purrr::map()`:
#> ℹ In index: 1.
#> ---
#> Backtrace:
#>      ▆
#>   1. ├─base::tryCatch(...)
#>   2. │ └─base (local) tryCatchList(expr, classes, parentenv, handlers)
#>   3. │   └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
#>   4. │     └─base (local) doTryCatch(return(expr), name, parentenv, handler)
#>   5. ├─wddsWizard::wdds_to_dcmi(...)
#>   6. │ └─purrr::imap(...)
#>   7. │   └─purrr::map2(.x, vec_index(.x), .f, ...)
#>   8. │     └─purrr:::map2_("list", .x, .y, .f, ..., .progress = .progress)
#>   9. │       ├─purrr:::with_indexed_errors(...)
#>  10. │       │ └─base::withCallingHandlers(...)
#>  11. │       ├─purrr:::call_with_cleanup(...)
#>  12. │       └─wddsWizard (local) .f(.x[[i]], .y[[i]], ...)
#>  13. │         └─wddsWizard::translate_to_dcmi(item = item, translation_map = x)
#>  14. │           └─purrr::map(...)
#>  15. │             └─purrr:::map_("list", .x, .f, ..., .progress = .progress)
#>  16. │               ├─purrr:::with_indexed_errors(...)
#>  17. │               │ └─base::withCallingHandlers(...)
#>  18. │               ├─purrr:::call_with_cleanup(...)
#>  19. │               └─wddsWizard (local) .f(.x[[i]], ...)
#>  20. │                 └─wddsWizard::wdds_to_dcmi(metadata_to_translate = x, translation_map = translation_map)
#>  21. │                   └─rlang::abort(message = msg)
#>  22. │                     └─rlang:::signal_abort(cnd, .file)
#>  23. │                       └─base::signalCondition(cnd)
#>  24. └─purrr (local) `<fn>`(`<rlng_rrr>`)
#>  25.   └─cli::cli_abort(...)
#> Caused by error in `wdds_to_dcmi()`:
#> ! license - CC0 - not in wddsWizard::spdx_licenses$licenseId.
#>  Update the rights property in your data.
#>  Potential matches: CC0-1.0
#> ---
#> Backtrace:
#>      ▆
#>   1. ├─base::tryCatch(...)
#>   2. │ └─base (local) tryCatchList(expr, classes, parentenv, handlers)
#>   3. │   └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
#>   4. │     └─base (local) doTryCatch(return(expr), name, parentenv, handler)
#>   5. └─wddsWizard::wdds_to_dcmi(...)
#>   6.   └─purrr::imap(...)
#>   7.     └─purrr::map2(.x, vec_index(.x), .f, ...)
#>   8.       └─purrr:::map2_("list", .x, .y, .f, ..., .progress = .progress)
#>   9.         ├─purrr:::with_indexed_errors(...)
#>  10.         │ └─base::withCallingHandlers(...)
#>  11.         ├─purrr:::call_with_cleanup(...)
#>  12.         └─wddsWizard (local) .f(.x[[i]], .y[[i]], ...)
#>  13.           └─wddsWizard::translate_to_dcmi(item = item, translation_map = x)
#>  14.             └─purrr::map(...)
#>  15.               └─purrr:::map_("list", .x, .f, ..., .progress = .progress)
#>  16.                 ├─purrr:::with_indexed_errors(...)
#>  17.                 │ └─base::withCallingHandlers(...)
#>  18.                 ├─purrr:::call_with_cleanup(...)
#>  19.                 └─wddsWizard (local) .f(.x[[i]], ...)
#>  20.                   └─wddsWizard::wdds_to_dcmi(metadata_to_translate = x, translation_map = translation_map)
```

The license abbreviation we used “CC0” is not one that is accepted by
Zenodo. To see all the licenses accepted by Zenodo, check out
[`wddsWizard::spdx_licenses`](https://viralemergence.github.io/wddsWizard/reference/spdx_licenses.md).

Lets update the `rights` property and see if our conversion works.

``` r

project_metadata_prepped$rights$rights <- "CC0-1.0"

dcmi_metadata <- wdds_to_dcmi(metadata_to_translate = project_metadata_prepped, translation_map = wdds_to_dcmi_map)
```

### Getting started with deposits

Now lets make a deposit in Zenodo using the deposits package.

The basic workflow looks like this:

1.  Connect to Zenodo server
2.  Create a DRAFT deposit
3.  Upload files to DRAFT deposit
4.  Review metadata and data
5.  Publish deposit

Zenodo provides two sites - production and sandbox. The production site
mints real DOIs and is where you ultimately want your data to be
deposited. The sandbox site provides a testing ground for you to
practice depositing data.

Both sites require an API key in order to programmatically create
deposits. Treat this key with extreme care because it allows access to
your Zenodo account. - [Sandbox API
Key](https://sandbox.zenodo.org/account/settings/applications/tokens/new/) -
[Production API
Key](https://zenodo.org/account/settings/applications/tokens/new/)

These can be stored securely in a number of ways, we will use the
`.Renviron` file so that keys are not hard-coded into your scripts.

    usethis::edit_r_environ()

Your `.Renviron` file should look something like the example below.
Remember that the file always has to end in a blank return.

    ZENODO_SANDBOX_TOKEN="TokenFromZenodoSandbox"
    ZENODO_TOKEN="TokenFromZenodoProduction"

After you’ve added the tokens to your environment, restart your R
session.

### Create deposit

``` r
tryCatch(
deposits::depositsClient$new(service = "zenodo",metadata = dcmi_metadata,sandbox = TRUE),
  error = function(e){print(e)}
)
#>   instancePath                                  schemaPath keyword
#> 1     /created #/properties/created/anyOf/0/anyOf/0/format  format
#> 2     /created #/properties/created/anyOf/0/anyOf/1/format  format
#> 3     /created          #/properties/created/anyOf/0/anyOf   anyOf
#> 4     /created           #/properties/created/anyOf/1/type    type
#> 5     /created                  #/properties/created/anyOf   anyOf
#>   params.format params.type                       message
#> 1          date        <NA>      must match format "date"
#> 2     date-time        <NA> must match format "date-time"
#> 3          <NA>        <NA>  must match a schema in anyOf
#> 4          <NA>      object                must be object
#> 5          <NA>        <NA>  must match a schema in anyOf
#> <simpleError: Stopping because the DCMI metadata terms listed above do not conform with the expected schema.>
```

Oh no! there is an issue with the `created` property. It would appear
that its not a properly formatted date!

Looking at the [dev
guide](https://developers.zenodo.org/#representation) on Zenodo we can
see that dates are supposed to be in ISO8601 so we need to use a
`YYYY-MM-DD` format.

``` r

# After reviewing my records, I realized we created this data on pi day.
dcmi_metadata$created <- "2022-03-14"

cli <- deposits::depositsClient$new(service = "zenodo",metadata = dcmi_metadata,sandbox = TRUE)

cli$deposit_new()

cli$deposit_upload_file("data/disease_data.csv")

cli$deposits$links$html[1]
```
