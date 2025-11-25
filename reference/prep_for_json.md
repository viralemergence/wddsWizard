# Prepare data for json

Uses[`purrr::modify_at`](https://purrr.tidyverse.org/reference/modify.html)
to apply a set of methods at specific locations in a list.

## Usage

``` r
prep_for_json(x, prep_methods_list = prep_methods())
```

## Arguments

- x:

  list. Named list of data frames, lists, or vectors. For methods to be
  applied, the names of the list items should match the names in the
  methods list

- prep_methods_list:

  list. Named list of methods where each items is a function to applied
  to corresponding items in x. Default is full list of methods from
  [`prep_methods()`](https://viralemergence.github.io/wddsWizard/reference/prep_methods.md).

## Value

Named list where methods have been applied.

## See also

Other JSON Prep:
[`clean_field_names()`](https://viralemergence.github.io/wddsWizard/reference/clean_field_names.md),
[`get_entity()`](https://viralemergence.github.io/wddsWizard/reference/get_entity.md),
[`prep_affiliation()`](https://viralemergence.github.io/wddsWizard/reference/prep_affiliation.md),
[`prep_array()`](https://viralemergence.github.io/wddsWizard/reference/prep_array.md),
[`prep_array_objects()`](https://viralemergence.github.io/wddsWizard/reference/prep_array_objects.md),
[`prep_atomic()`](https://viralemergence.github.io/wddsWizard/reference/prep_atomic.md),
[`prep_creators()`](https://viralemergence.github.io/wddsWizard/reference/prep_creators.md),
[`prep_data()`](https://viralemergence.github.io/wddsWizard/reference/prep_data.md),
[`prep_descriptions()`](https://viralemergence.github.io/wddsWizard/reference/prep_descriptions.md),
[`prep_from_metadata_template()`](https://viralemergence.github.io/wddsWizard/reference/prep_from_metadata_template.md),
[`prep_fundingReferences()`](https://viralemergence.github.io/wddsWizard/reference/prep_fundingReferences.md),
[`prep_identifier()`](https://viralemergence.github.io/wddsWizard/reference/prep_identifier.md),
[`prep_language()`](https://viralemergence.github.io/wddsWizard/reference/prep_language.md),
[`prep_methodology()`](https://viralemergence.github.io/wddsWizard/reference/prep_methodology.md),
[`prep_methods()`](https://viralemergence.github.io/wddsWizard/reference/prep_methods.md),
[`prep_nameIdentifiers()`](https://viralemergence.github.io/wddsWizard/reference/prep_nameIdentifiers.md),
[`prep_object()`](https://viralemergence.github.io/wddsWizard/reference/prep_object.md),
[`prep_publicationYear()`](https://viralemergence.github.io/wddsWizard/reference/prep_publicationYear.md),
[`prep_relatedIdentifiers()`](https://viralemergence.github.io/wddsWizard/reference/prep_relatedIdentifiers.md),
[`prep_rights()`](https://viralemergence.github.io/wddsWizard/reference/prep_rights.md),
[`prep_subjects()`](https://viralemergence.github.io/wddsWizard/reference/prep_subjects.md),
[`prep_titles()`](https://viralemergence.github.io/wddsWizard/reference/prep_titles.md)

## Examples

``` r
wddsWizard::becker_project_metadata |>
  prep_for_json()
#> $creators
#> $creators[[1]]
#>                 name givenName familyName
#> [x] Daniel J. Becker Daniel J.     Becker
#>                                                                                   affiliation
#> [x] Department of Biology, University of Oklahoma, Norman, OK, USA, https://ror.org/02aqsxs83
#>                                  nameIdentifiers
#> [x] https://orcid.org/0000-0003-4315-8628, ORCID
#> 
#> $creators[[2]]
#>                name   givenName familyName
#> [x] Guang-Sheng Lei Guang-Sheng        Lei
#>                                                                                                                                  affiliation
#> [x] Department of Pathology and Laboratory Medicine, Indiana University School of Medicine, Indianapolis, IN, USA, https://ror.org/02ets8c94
#> 
#> 
#> $descriptions
#> $descriptions[[1]]
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 description
#> [x] Bats can harbor many pathogens without showing disease. However, the mechanisms by which bats resolve these infections or limit pathology remain unclear. To illuminate the bat immune response to coronaviruses, viruses with high public health significance, we will use serum proteomics to assess broad differences in immune proteins of uninfected and infected vampire bats (Desmodus rotundus). In contrast to global profiling techniques of blood such as transcriptomics, proteomics provides a unique perspective into immunology, as the serum proteome includes proteins from not only blood but also those secreted from proximal tissues. Here, we expand our recent work on the serum proteome of wild vampire bats (Desmodus rotundus) to better understand CoV pathogenesis. Across 19 bats sampled in 2019 in northern Belize with available sera, we detected CoVs in oral or rectal swabs from four individuals. We used data independent acquisition-based mass spectrometry to profile and compare the undepleted serum proteome of these 19 bats. These results will provide much needed insight into changes in the bat serum proteome in response to coronavirus infection.
#>     descriptionType
#> [x]        Abstract
#> 
#> 
#> $fundingReferences
#> $fundingReferences[[1]]
#>                      funderName                     funderIdentifier
#> [x] National Geographic Society http://dx.doi.org/10.13039/100006733
#>       awardNumber
#> [x] NGS-55503R-19
#> 
#> $fundingReferences[[2]]
#>             funderName                     funderIdentifier
#> [x] Indiana University http://dx.doi.org/10.13039/100006733
#> 
#> $fundingReferences[[3]]
#>                funderName                     funderIdentifier
#> [x] College of Charleston http://dx.doi.org/10.13039/100009789
#> 
#> 
#> $identifier
#> $identifier[[1]]
#>                identifier identifierType
#> [x] 10.5072/zenodo.168108            DOI
#> 
#> 
#> $language
#> [x] "en"
#> 
#> $methodology
#> $methodology$eventBased
#> [x] false
#> 
#> $methodology$archival
#> [x] false
#> 
#> 
#> $publicationYear
#> [x] "2022"
#> 
#> $relatedIdentifiers
#> $relatedIdentifiers[[1]]
#>                                                 relatedIdentifier
#> [x] https://pharos.viralemergence.org/projects/?prj=prjRPayEvMecN
#>     relatedIdentifierType relationType
#> [x]                   URL  IsVersionOf
#> 
#> $relatedIdentifiers[[2]]
#>             relatedIdentifier relatedIdentifierType relationType
#> [x] 10.3389/fviro.2022.862961                   DOI     IsPartOf
#> 
#> 
#> $rights
#> $rights[[1]]
#>     rights
#> [x]    CC0
#> 
#> 
#> $subjects
#> $subjects[[1]]
#>        subject
#> [x] Proteomics
#> 
#> $subjects[[2]]
#>             subject
#> [x] Immune Response
#> 
#> 
#> $titles
#> $titles[[1]]
#>                                                                            title
#> [x] Serum proteomics of coronavirus shedding in vampire bats (Desmodus rotundus)
#> 
#> 

a <- list("hello_world" = 1:10)
methods_list <- list(
  "hello_world" = function(x) {
    x * 2
  },
  "unused_method" = function(x) {
    x / 2
  }
)
prep_for_json(a, methods_list)
#> $hello_world
#>  [1]  2  4  6  8 10 12 14 16 18 20
#> 
```
