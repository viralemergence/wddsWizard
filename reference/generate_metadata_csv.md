# Generate minimal project metadata template

This function allows you to generate a minimal metadata template for
your project. You provide certain values and it generates a csv based on
those values. Any parameter that starts with num takes an integer and
creates repeat entries in the metadata csv. All other values take a
string or logical input and will prepopulate that section of the
metadata csv.

## Usage

``` r
generate_metadata_csv(
  file_path,
  event_based,
  archival,
  num_creators,
  num_titles,
  identifier,
  identifier_type,
  num_subjects,
  publication_year,
  rights,
  language,
  num_descriptions,
  num_fundingReferences,
  num_related_identifiers,
  write_output = TRUE
)
```

## Arguments

- file_path:

  String. Where should the CSV file be saved?

- event_based:

  Logical. Whether or not research was conducted in response to a known
  or suspected infectious disease outbreak, observed animal morbidity or
  mortality, etc.

- archival:

  Logical. Whether samples were from an archival source (e.g., museum
  collections, biobanks).

- num_creators:

  Integer. Number of creators for a work.

- num_titles:

  Integer. Number of titles for a work.

- identifier:

  String. A unique string that identifies a resource. Should be a DOI

- identifier_type:

  String. Should be DOI

- num_subjects:

  Integer. Number of subjects. Subject, keyword, classification code, or
  key phrase describing the resource

- publication_year:

  String. Year when work was published

- rights:

  String. Use one of the rights identifiers found here
  https://spdx.org/licenses/

- language:

  String. The primary language of the resource.

- num_descriptions:

  Integer. Number of descriptions to add to the csv. All additional
  information that does not fit in any of the other categories. May be
  used for technical information or detailed information associated with
  a scientific instrument

- num_fundingReferences:

  Integer. Number of funders to add to the csv. Name and other
  identifying information of a funding provider

- num_related_identifiers:

  Integer. Number of other works you would like to link to.

- write_output:

  Logical. Should the file be written?

## Value

data.frame

## See also

Other Project Metadata:
[`download_oa_item()`](https://viralemergence.github.io/wddsWizard/reference/download_oa_item.md),
[`expand_tidy_dfs()`](https://viralemergence.github.io/wddsWizard/reference/expand_tidy_dfs.md),
[`extract_metadata_from_doi()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_from_doi.md),
[`extract_metadata_oa()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_oa.md),
[`generate_repeat_dfs()`](https://viralemergence.github.io/wddsWizard/reference/generate_repeat_dfs.md),
[`make_simple_df()`](https://viralemergence.github.io/wddsWizard/reference/make_simple_df.md)

## Examples

``` r
generate_metadata_csv(file_path = "test.csv",
event_based = TRUE,
archival = FALSE,
num_creators = 10,
num_titles = 1,
identifier = "https://doi.org/10.1080/example.doi",
identifier_type = "doi",
num_subjects = 5,
publication_year = "2025",
rights = "cc-by",
language = "en",
num_descriptions = 1,
num_fundingReferences = 4,
num_related_identifiers= 5,
write_output = FALSE) # change to TRUE to write the csv
#>                     Group                Variable
#> 1             Methodology             Event Based
#> 2                                        Archival
#> 3              Creators 1                    Name
#> 4                                      Given Name
#> 5                                     Family Name
#> 6                                 Name Identifier
#> 7                                     Affiliation
#> 8                          Affiliation Identifier
#> 9              Creators 2                    Name
#> 10                                     Given Name
#> 11                                    Family Name
#> 12                                Name Identifier
#> 13                                    Affiliation
#> 14                         Affiliation Identifier
#> 15             Creators 3                    Name
#> 16                                     Given Name
#> 17                                    Family Name
#> 18                                Name Identifier
#> 19                                    Affiliation
#> 20                         Affiliation Identifier
#> 21             Creators 4                    Name
#> 22                                     Given Name
#> 23                                    Family Name
#> 24                                Name Identifier
#> 25                                    Affiliation
#> 26                         Affiliation Identifier
#> 27             Creators 5                    Name
#> 28                                     Given Name
#> 29                                    Family Name
#> 30                                Name Identifier
#> 31                                    Affiliation
#> 32                         Affiliation Identifier
#> 33             Creators 6                    Name
#> 34                                     Given Name
#> 35                                    Family Name
#> 36                                Name Identifier
#> 37                                    Affiliation
#> 38                         Affiliation Identifier
#> 39             Creators 7                    Name
#> 40                                     Given Name
#> 41                                    Family Name
#> 42                                Name Identifier
#> 43                                    Affiliation
#> 44                         Affiliation Identifier
#> 45             Creators 8                    Name
#> 46                                     Given Name
#> 47                                    Family Name
#> 48                                Name Identifier
#> 49                                    Affiliation
#> 50                         Affiliation Identifier
#> 51             Creators 9                    Name
#> 52                                     Given Name
#> 53                                    Family Name
#> 54                                Name Identifier
#> 55                                    Affiliation
#> 56                         Affiliation Identifier
#> 57            Creators 10                    Name
#> 58                                     Given Name
#> 59                                    Family Name
#> 60                                Name Identifier
#> 61                                    Affiliation
#> 62                         Affiliation Identifier
#> 63               Titles 1                   Title
#> 64             Identifier              Identifier
#> 65                                Identifier Type
#> 66             Subjects 1                 Subject
#> 67             Subjects 2                 Subject
#> 68             Subjects 3                 Subject
#> 69             Subjects 4                 Subject
#> 70             Subjects 5                 Subject
#> 71       Publication Year        Publication Year
#> 72                 Rights                  Rights
#> 73               Language                Language
#> 74         Descriptions 1             Description
#> 75                               Description Type
#> 76   Funding References 1             Funder Name
#> 77                              Funder Identifier
#> 78                                   Award Number
#> 79                                      Award URI
#> 80                                    Award Title
#> 81   Funding References 2             Funder Name
#> 82                              Funder Identifier
#> 83                                   Award Number
#> 84                                      Award URI
#> 85                                    Award Title
#> 86   Funding References 3             Funder Name
#> 87                              Funder Identifier
#> 88                                   Award Number
#> 89                                      Award URI
#> 90                                    Award Title
#> 91   Funding References 4             Funder Name
#> 92                              Funder Identifier
#> 93                                   Award Number
#> 94                                      Award URI
#> 95                                    Award Title
#> 96  Related Identifiers 1      Related Identifier
#> 97                        Related Identifier Type
#> 98                                  Relation Type
#> 99  Related Identifiers 2      Related Identifier
#> 100                       Related Identifier Type
#> 101                                 Relation Type
#> 102 Related Identifiers 3      Related Identifier
#> 103                       Related Identifier Type
#> 104                                 Relation Type
#> 105 Related Identifiers 4      Related Identifier
#> 106                       Related Identifier Type
#> 107                                 Relation Type
#> 108 Related Identifiers 5      Related Identifier
#> 109                       Related Identifier Type
#> 110                                 Relation Type
#>                                   Value
#> 1                                  TRUE
#> 2                                 FALSE
#> 3                                      
#> 4                                      
#> 5                                      
#> 6                                      
#> 7                                      
#> 8                                      
#> 9                                      
#> 10                                     
#> 11                                     
#> 12                                     
#> 13                                     
#> 14                                     
#> 15                                     
#> 16                                     
#> 17                                     
#> 18                                     
#> 19                                     
#> 20                                     
#> 21                                     
#> 22                                     
#> 23                                     
#> 24                                     
#> 25                                     
#> 26                                     
#> 27                                     
#> 28                                     
#> 29                                     
#> 30                                     
#> 31                                     
#> 32                                     
#> 33                                     
#> 34                                     
#> 35                                     
#> 36                                     
#> 37                                     
#> 38                                     
#> 39                                     
#> 40                                     
#> 41                                     
#> 42                                     
#> 43                                     
#> 44                                     
#> 45                                     
#> 46                                     
#> 47                                     
#> 48                                     
#> 49                                     
#> 50                                     
#> 51                                     
#> 52                                     
#> 53                                     
#> 54                                     
#> 55                                     
#> 56                                     
#> 57                                     
#> 58                                     
#> 59                                     
#> 60                                     
#> 61                                     
#> 62                                     
#> 63                                     
#> 64  https://doi.org/10.1080/example.doi
#> 65                                  doi
#> 66                                     
#> 67                                     
#> 68                                     
#> 69                                     
#> 70                                     
#> 71                                 2025
#> 72                                cc-by
#> 73                                   en
#> 74                                     
#> 75                                     
#> 76                                     
#> 77                                     
#> 78                                     
#> 79                                     
#> 80                                     
#> 81                                     
#> 82                                     
#> 83                                     
#> 84                                     
#> 85                                     
#> 86                                     
#> 87                                     
#> 88                                     
#> 89                                     
#> 90                                     
#> 91                                     
#> 92                                     
#> 93                                     
#> 94                                     
#> 95                                     
#> 96                                     
#> 97                                     
#> 98                                     
#> 99                                     
#> 100                                    
#> 101                                    
#> 102                                    
#> 103                                    
#> 104                                    
#> 105                                    
#> 106                                    
#> 107                                    
#> 108                                    
#> 109                                    
#> 110                                    
```
