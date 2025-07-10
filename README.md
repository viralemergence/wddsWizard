# wddsWizard 🧙 

<!-- badges: start -->
[![R-CMD-check](https://github.com/viralemergence/wddsWizard/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/viralemergence/wddsWizard/actions/workflows/R-CMD-check.yaml)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![wddsWizard status badge](https://viralemergence.r-universe.dev/wddsWizard/badges/version)](https://viralemergence.r-universe.dev/wddsWizard)
[![Codecov test coverage](https://codecov.io/gh/viralemergence/wddsWizard/graph/badge.svg)](https://app.codecov.io/gh/viralemergence/wddsWizard)
<!-- badges: end -->


This is an R package for validating data against the Wildlife Disease Data Standard. 
It allows users to access different versions of the data standard, restructure data, and validate data sets. 

See our paper [A minimum data standard for wildlife disease research and surveillance](https://www.nature.com/articles/s41597-025-05332-x) for discussions of appropriate use and more complex data structures (e.g. pooled samples, parasites with an arthropod vector, etc.) for the data standard.

See the [Getting Started](https://viralemergence.github.io/wddsWizard/articles/wddsWizard.html) tutorial for more information about how to use the package. 


## Installation

Install from github.

```
devtools::install_github("viralemergence/wddsWizard")
```

Install from Runiverse

```
install.packages('wddsWizard', repos = c('https://viralemergence.r-universe.dev', 'https://cloud.r-project.org'))
```

## Briefest of demos

```
## assumes you made a data package. See getting started vignette

schema <- wdds_json(version = "latest", file = "wdds_schema.json")

wdds_validator <- jsonvalidate::json_validator(schema,engine = "ajv")

project_validation <- wdds_validator(data_package_json,verbose = TRUE)

if(project_validation){
  print("Your data package is valid! 🎊 ")
} else {
errors <- attributes(project_validation)
errors$errors
}

```


## Why do we need a data standard?

Data standards facilitate the sharing, (re)use, and aggregation of data by
humans and machines through the use of a common structure, set of properties, and vocabulary. 

Using a data standard makes it easier to share datasets and reproduce results. Data standards facilitate sharing by lowering the effort it takes to document the dataset. 
Sharing data makes it easier to reproduce results. 
Sharing data is especially important in disciplines like disease ecology where producing datasets is both resource intensive and limited, making it unlikely that someone will be able to replicate field work for the sake of verifying a finding.
Being able to reproduce results increases confidence in findings and allows others (most likely the original dataset producers) to build on those results. 

Compliance with a data standard eases data interpretation. 
Because the data have been validated against the standard, a researcher knows that fields in the dataset meet set definitions and the data conform to a certain structure. 
Researchers can also identify deviations from the standard more readily because of the descriptions and examples provided in the standard.

Compliant datasets can be aggregated with other datasets that meet the data standard.
As the number of datasets that use the standard grows, the questions that researchers can ask of the data changes.
For example, if we have datasets describing disease incidence for some pathogen from dozens of locations across multiple regions, we can explore general modeling frameworks for that pathogen using a unified dataset. 

By using a data standard we can contribute to a virtuous cycle that promotes high quality open and reproducible science through sharing, reuse, and aggregation of datasets. 

## How do I use this package and the Wildlife Disease Data Standard?

This package can be used to explore Wildlife Disease Data Standard and validate data. 

See our paper [A minimum data standard for wildlife disease research and surveillance](https://www.nature.com/articles/s41597-025-05332-x) for discussions of appropriate use and  more complex data structures (e.g. pooled samples, parasites with an arthropod vector, etc.).

See the [Getting Started](https://viralemergence.github.io/wddsWizard/articles/wddsWizard.html) vignette for code examples and a more hands on approach to getting familiar with the package.

### Starting from scratch - don't have any data, yet!

We strongly recommend creating a Data Management Plan (DMP) at the beginning of any project and seriously considering the data life cycle for your project.

Use our CSV templates and the data standard as a guide for storing data. 
Make sure that at least the minimum required fields are captured in data collection, and that they match the data standard.
Lab and field data may not immediately come out in a "tidy" format but as long as all properties are captured and data remain disaggregated (1 row = 1 observation), it should be possible to reshape the data to be compatible with the standard.


### Starting from an existing project - I've got data!?

This is potentially more challenging than starting from scratch and requires harmonizing your data and the data standard.
First, check that your data are or can be disaggregated to a 1 row = 1 observation tidy data model. 
Then, cross-walk the fields from your data with the properties in the standard and make sure that your data contain all the required fields. 
Next, start to reshape it into a single, tidy, table.
You will need to re-name fields that correspond to the those in the standard. 

### Validating your data

This package has vignettes describing how to move from CSV/excel to JSON for
[project metadata](https://viralemergence.github.io/wddsWizard/articles/project_metadata.html) and [wildlife disease data](https://viralemergence.github.io/wddsWizard/articles/disease_data.html).

## How does validation work?

This package uses [JSON schemas](https://json-schema.org/) and the [AJV engine](https://ajv.js.org/) to do the validation.

See [Schema Overview](https://viralemergence.github.io/wddsWizard/articles/schema_overview.html) for more information about the data standard and json schemas.


## Related Packages

- [jsonvalidate](https://docs.ropensci.org/jsonvalidate/) - JSON schema validation 
- [deposits package](https://docs.ropensci.org/deposits/) - a universal client for accessing data from different scientific repositories. 
- [zen4R package](https://github.com/eblondel/zen4R/wiki) - a zenodo specific client for accessing data

## Acknowledgements

The authors of the package are grateful for the support of the Verena Institute,
Carlson Lab, Yale School of Public Health. 
