# Extract Project Metadata from DOI

Some works are explicitly connected to a publication and the metadata
for that publication are fairly complete. Instead of re-writing the
metadata, it would be better to extract it and transform it.

## Usage

``` r
extract_metadata_from_doi(doi, file_path, write_output = TRUE)
```

## Arguments

- doi:

  String. DOI for a published work

- file_path:

  String. Where should the output be written?

- write_output:

  Logical. Should the output be written to a file?

## Value

data frame. A data frame structured in the same way as the metadata
template csv.

## See also

Other Project Metadata:
[`download_oa_item()`](https://viralemergence.github.io/wddsWizard/reference/download_oa_item.md),
[`expand_tidy_dfs()`](https://viralemergence.github.io/wddsWizard/reference/expand_tidy_dfs.md),
[`extract_metadata_oa()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_oa.md),
[`generate_metadata_csv()`](https://viralemergence.github.io/wddsWizard/reference/generate_metadata_csv.md),
[`generate_repeat_dfs()`](https://viralemergence.github.io/wddsWizard/reference/generate_repeat_dfs.md),
[`make_simple_df()`](https://viralemergence.github.io/wddsWizard/reference/make_simple_df.md)

## Examples

``` r
doi <-"doi.org/10.1038/s41597-025-05332-x"
extract_metadata_from_doi(doi = doi,write_output=FALSE)
#> → Starting now, at 2025-11-25 22:30:39.037184
#> Getting Affiliations ■■■■■■■■                          23% |  ETA: 11s
#> Getting Affiliations ■■■■■■■■■■                        31% |  ETA: 12s
#> Getting Affiliations ■■■■■■■■■■■■■■                    42% |  ETA: 12s
#> Getting Affiliations ■■■■■■■■■■■■■■■■■■■■■             65% |  ETA:  6s
#> Getting Funder Info ■■■                                6% |  ETA: 17s
#>                     Group                Variable
#> 1             Methodology             Event Based
#> 2                                        Archival
#> 3              Creators 1                    Name
#> 4                                     Family Name
#> 5                                      Given Name
#> 6                                 Name Identifier
#> 7                                     Affiliation
#> 8                          Affiliation Identifier
#> 9              Creators 2                    Name
#> 10                                    Family Name
#> 11                                     Given Name
#> 12                                Name Identifier
#> 13                                    Affiliation
#> 14                         Affiliation Identifier
#> 15             Creators 3                    Name
#> 16                                    Family Name
#> 17                                     Given Name
#> 18                                Name Identifier
#> 19                                    Affiliation
#> 20                         Affiliation Identifier
#> 21             Creators 4                    Name
#> 22                                    Family Name
#> 23                                     Given Name
#> 24                                Name Identifier
#> 25                                    Affiliation
#> 26                         Affiliation Identifier
#> 27             Creators 5                    Name
#> 28                                    Family Name
#> 29                                     Given Name
#> 30                                Name Identifier
#> 31                                    Affiliation
#> 32                         Affiliation Identifier
#> 33             Creators 6                    Name
#> 34                                    Family Name
#> 35                                     Given Name
#> 36                                Name Identifier
#> 37                                    Affiliation
#> 38                         Affiliation Identifier
#> 39             Creators 7                    Name
#> 40                                    Family Name
#> 41                                     Given Name
#> 42                                Name Identifier
#> 43                                    Affiliation
#> 44                         Affiliation Identifier
#> 45             Creators 8                    Name
#> 46                                    Family Name
#> 47                                     Given Name
#> 48                                Name Identifier
#> 49                                    Affiliation
#> 50                         Affiliation Identifier
#> 51             Creators 9                    Name
#> 52                                    Family Name
#> 53                                     Given Name
#> 54                                Name Identifier
#> 55                                    Affiliation
#> 56                         Affiliation Identifier
#> 57            Creators 10                    Name
#> 58                                    Family Name
#> 59                                     Given Name
#> 60                                Name Identifier
#> 61                                    Affiliation
#> 62                         Affiliation Identifier
#> 63            Creators 11                    Name
#> 64                                    Family Name
#> 65                                     Given Name
#> 66                                Name Identifier
#> 67                                    Affiliation
#> 68                         Affiliation Identifier
#> 69            Creators 12                    Name
#> 70                                    Family Name
#> 71                                     Given Name
#> 72                                Name Identifier
#> 73                                    Affiliation
#> 74                         Affiliation Identifier
#> 75            Creators 13                    Name
#> 76                                    Family Name
#> 77                                     Given Name
#> 78                                Name Identifier
#> 79                                    Affiliation
#> 80                         Affiliation Identifier
#> 81            Creators 14                    Name
#> 82                                    Family Name
#> 83                                     Given Name
#> 84                                Name Identifier
#> 85                                    Affiliation
#> 86                         Affiliation Identifier
#> 87            Creators 15                    Name
#> 88                                    Family Name
#> 89                                     Given Name
#> 90                                Name Identifier
#> 91                                    Affiliation
#> 92                         Affiliation Identifier
#> 93            Creators 16                    Name
#> 94                                    Family Name
#> 95                                     Given Name
#> 96                                Name Identifier
#> 97                                    Affiliation
#> 98                         Affiliation Identifier
#> 99            Creators 17                    Name
#> 100                                   Family Name
#> 101                                    Given Name
#> 102                               Name Identifier
#> 103                                   Affiliation
#> 104                        Affiliation Identifier
#> 105           Creators 18                    Name
#> 106                                   Family Name
#> 107                                    Given Name
#> 108                               Name Identifier
#> 109                                   Affiliation
#> 110                        Affiliation Identifier
#> 111           Creators 19                    Name
#> 112                                   Family Name
#> 113                                    Given Name
#> 114                               Name Identifier
#> 115                                   Affiliation
#> 116                        Affiliation Identifier
#> 117           Creators 20                    Name
#> 118                                   Family Name
#> 119                                    Given Name
#> 120                               Name Identifier
#> 121                                   Affiliation
#> 122                        Affiliation Identifier
#> 123           Creators 21                    Name
#> 124                                   Family Name
#> 125                                    Given Name
#> 126                               Name Identifier
#> 127                                   Affiliation
#> 128                        Affiliation Identifier
#> 129           Creators 22                    Name
#> 130                                   Family Name
#> 131                                    Given Name
#> 132                               Name Identifier
#> 133                                   Affiliation
#> 134                        Affiliation Identifier
#> 135           Creators 23                    Name
#> 136                                   Family Name
#> 137                                    Given Name
#> 138                               Name Identifier
#> 139                                   Affiliation
#> 140                        Affiliation Identifier
#> 141           Creators 24                    Name
#> 142                                   Family Name
#> 143                                    Given Name
#> 144                               Name Identifier
#> 145                                   Affiliation
#> 146                        Affiliation Identifier
#> 147           Creators 25                    Name
#> 148                                   Family Name
#> 149                                    Given Name
#> 150                               Name Identifier
#> 151                                   Affiliation
#> 152                        Affiliation Identifier
#> 153           Creators 26                    Name
#> 154                                   Family Name
#> 155                                    Given Name
#> 156                               Name Identifier
#> 157                                   Affiliation
#> 158                        Affiliation Identifier
#> 159              Titles 1                   title
#> 160       publicationYear         publicationYear
#> 161              language                language
#> 162        Descriptions 1             Description
#> 163                              Description Type
#> 164  Funding References 1             Funder Name
#> 165                             Funder Identifier
#> 166                                  Award Number
#> 167                                     Award URI
#> 168                                      Award ID
#> 169  Funding References 2             Funder Name
#> 170                             Funder Identifier
#> 171                                  Award Number
#> 172                                     Award URI
#> 173                                      Award ID
#> 174  Funding References 3             Funder Name
#> 175                             Funder Identifier
#> 176                                  Award Number
#> 177                                     Award URI
#> 178                                      Award ID
#> 179  Funding References 4             Funder Name
#> 180                             Funder Identifier
#> 181                                  Award Number
#> 182                                     Award URI
#> 183                                      Award ID
#> 184  Funding References 5             Funder Name
#> 185                             Funder Identifier
#> 186                                  Award Number
#> 187                                     Award URI
#> 188                                      Award ID
#> 189  Funding References 6             Funder Name
#> 190                             Funder Identifier
#> 191                                  Award Number
#> 192                                     Award URI
#> 193                                      Award ID
#> 194  Funding References 7             Funder Name
#> 195                             Funder Identifier
#> 196                                  Award Number
#> 197                                     Award URI
#> 198                                      Award ID
#> 199  Funding References 8             Funder Name
#> 200                             Funder Identifier
#> 201                                  Award Number
#> 202                                     Award URI
#> 203                                      Award ID
#> 204  Funding References 9             Funder Name
#> 205                             Funder Identifier
#> 206                                  Award Number
#> 207                                     Award URI
#> 208                                      Award ID
#> 209 Funding References 10             Funder Name
#> 210                             Funder Identifier
#> 211                                  Award Number
#> 212                                     Award URI
#> 213                                      Award ID
#> 214 Funding References 11             Funder Name
#> 215                             Funder Identifier
#> 216                                  Award Number
#> 217                                     Award URI
#> 218                                      Award ID
#> 219 Funding References 12             Funder Name
#> 220                             Funder Identifier
#> 221                                  Award Number
#> 222                                     Award URI
#> 223                                      Award ID
#> 224 Funding References 13             Funder Name
#> 225                             Funder Identifier
#> 226                                  Award Number
#> 227                                     Award URI
#> 228                                      Award ID
#> 229 Funding References 14             Funder Name
#> 230                             Funder Identifier
#> 231                                  Award Number
#> 232                                     Award URI
#> 233                                      Award ID
#> 234 Funding References 15             Funder Name
#> 235                             Funder Identifier
#> 236                                  Award Number
#> 237                                     Award URI
#> 238                                      Award ID
#> 239 Funding References 16             Funder Name
#> 240                             Funder Identifier
#> 241                                  Award Number
#> 242                                     Award URI
#> 243                                      Award ID
#> 244 Funding References 17             Funder Name
#> 245                             Funder Identifier
#> 246                                  Award Number
#> 247                                     Award URI
#> 248                                      Award ID
#> 249            Subjects 1                 Subject
#> 250            Subjects 2                 Subject
#> 251            Subjects 3                 Subject
#> 252            Subjects 4                 Subject
#> 253            Subjects 5                 Subject
#> 254            Subjects 6                 Subject
#> 255            Subjects 7                 Subject
#> 256            Subjects 8                 Subject
#> 257            Subjects 9                 Subject
#> 258           Subjects 10                 Subject
#> 259           Subjects 11                 Subject
#> 260           Subjects 12                 Subject
#> 261           Subjects 13                 Subject
#> 262           Subjects 14                 Subject
#> 263           Subjects 15                 Subject
#> 264           Subjects 16                 Subject
#> 265 Related Identifiers 1      Related Identifier
#> 266                       Related Identifier Type
#> 267                                 Relation Type
#>                                                                                                                                                     Value
#> 1                                                                                                                                                   FALSE
#> 2                                                                                                                                                   FALSE
#> 3                                                                                                                                      Collin J Schwantes
#> 4                                                                                                                                               Schwantes
#> 5                                                                                                                                               Collin J 
#> 6                                                                                                                   https://orcid.org/0000-0002-9882-941X
#> 7                                       Department of Epidemiology of Microbial Diseases, Yale University, New Haven, CT, USA. collin.schwantes@yale.edu.
#> 8                                                                                                                               https://ror.org/03v76x132
#> 9                                                                                                                                       Cecilia A Sánchez
#> 10                                                                                                                                                Sánchez
#> 11                                                                                                                                             Cecilia A 
#> 12                                                                                                                  https://orcid.org/0000-0002-1141-6816
#> 13                                       Department of Epidemiology of Microbial Diseases, Yale University, New Haven, CT, USA. cecilia.sanchez@yale.edu.
#> 14                                                                                                                              https://ror.org/03v76x132
#> 15                                                                                                                                           Tess Stevens
#> 16                                                                                                                                                Stevens
#> 17                                                                                                                                                  Tess 
#> 18                                                                                                                                                   <NA>
#> 19                                                             Center for Global Health Science and Security, Georgetown University, Washington, DC, USA.
#> 20                                                                                                                              https://ror.org/05vzafd60
#> 21                                                                                                                                         Ryan Zimmerman
#> 22                                                                                                                                              Zimmerman
#> 23                                                                                                                                                  Ryan 
#> 24                                                                                                                  https://orcid.org/0000-0002-4376-7418
#> 25                                                             Center for Global Health Science and Security, Georgetown University, Washington, DC, USA.
#> 26                                                                                                                              https://ror.org/05vzafd60
#> 27                                                                                                                                            Greg Albery
#> 28                                                                                                                                                 Albery
#> 29                                                                                                                                                  Greg 
#> 30                                                                                                                  https://orcid.org/0000-0001-6260-2662
#> 31                                                                                     Department of Biology, Georgetown University, Washington, DC, USA.
#> 32                                                                                                                              https://ror.org/05vzafd60
#> 33                                                                                                                                        Daniel J Becker
#> 34                                                                                                                                                 Becker
#> 35                                                                                                                                              Daniel J 
#> 36                                                                                                                  https://orcid.org/0000-0003-4315-8628
#> 37                                                                                School of Biological Sciences, University of Oklahoma, Norman, OK, USA.
#> 38                                                                                                                              https://ror.org/02aqsxs83
#> 39                                                                                                                                        Cole B Brookson
#> 40                                                                                                                                               Brookson
#> 41                                                                                                                                                Cole B 
#> 42                                                                                                                  https://orcid.org/0000-0003-1237-4096
#> 43                                                                     Département de Sciences Biologiques, Université de Montréal, Montreal, QC, Canada.
#> 44                                                                                                                              https://ror.org/0161xgx34
#> 45                                                                                                                                       Rebekah C Kading
#> 46                                                                                                                                                 Kading
#> 47                                                                                                                                             Rebekah C 
#> 48                                                                                                                  https://orcid.org/0000-0002-4996-915X
#> 49  Center for Vector-borne Infectious Diseases, Department of Microbiology, Immunology, and Pathology, Colorado State University, Fort Collins, CO, USA.
#> 50                                                                                                                              https://ror.org/03k1gpj17
#> 51                                                                                                                                          Carl N Keiser
#> 52                                                                                                                                                 Keiser
#> 53                                                                                                                                                Carl N 
#> 54                                                                                                                  https://orcid.org/0000-0002-4936-7810
#> 55                                                                             Emerging Pathogens Institute, University of Florida, Gainesville, FL, USA.
#> 56                                                                                                                              https://ror.org/02y3ad647
#> 57                                                                                                                                    Shashank Khandelwal
#> 58                                                                                                                                             Khandelwal
#> 59                                                                                                                                              Shashank 
#> 60                                                                                                                                                   <NA>
#> 61                                                                                                                    Blue Tiger, LLC, Timonium, MD, USA.
#> 62                                                                                                                              https://ror.org/01mzcg363
#> 63                                                                                                                                Stephanie Kramer-Schadt
#> 64                                                                                                                                          Kramer-Schadt
#> 65                                                                                                                                             Stephanie 
#> 66                                                                                                                  https://orcid.org/0000-0002-9269-4446
#> 67                                                   Department of Ecological Dynamics, Leibniz Institute for Zoo and Wildlife Research, Berlin, Germany.
#> 68                                                                                                                              https://ror.org/05nywn832
#> 69                                                                                                                                    Raphael Krut-Landau
#> 70                                                                                                                                            Krut-Landau
#> 71                                                                                                                                               Raphael 
#> 72                                                                                                                                                   <NA>
#> 73                                                                                                                    Blue Tiger, LLC, Timonium, MD, USA.
#> 74                                                                                                                              https://ror.org/01mzcg363
#> 75                                                                                                                                          Clifton McKee
#> 76                                                                                                                                                  McKee
#> 77                                                                                                                                               Clifton 
#> 78                                                                                                                  https://orcid.org/0000-0002-6149-0598
#> 79                                                       Department of Epidemiology, Johns Hopkins Bloomberg School of Public Health, Baltimore, MD, USA.
#> 80                                                                                                                              https://ror.org/00za53h95
#> 81                                                                                                                                Diego Montecino-Latorre
#> 82                                                                                                                                      Montecino-Latorre
#> 83                                                                                                                                                 Diego 
#> 84                                                                                                                  https://orcid.org/0000-0002-5009-5939
#> 85                                                                                      Wildlife Conservation Society, Health Program, New York, NY, USA.
#> 86                                                                                                                              https://ror.org/01xnsst08
#> 87                                                                                                                                         Zoe O'Donoghue
#> 88                                                                                                                                             O'Donoghue
#> 89                                                                                                                                                   Zoe 
#> 90                                                                                                                                                   <NA>
#> 91                                                                 Department of Epidemiology of Microbial Diseases, Yale University, New Haven, CT, USA.
#> 92                                                                                                                              https://ror.org/03v76x132
#> 93                                                                                                                                          Sarah H Olson
#> 94                                                                                                                                                  Olson
#> 95                                                                                                                                               Sarah H 
#> 96                                                                                                                  https://orcid.org/0000-0002-8484-9006
#> 97                                                                                      Wildlife Conservation Society, Health Program, New York, NY, USA.
#> 98                                                                                                                              https://ror.org/01xnsst08
#> 99                                                                                                                                            Mika O'Shea
#> 100                                                                                                                                                O'Shea
#> 101                                                                                                                                                 Mika 
#> 102                                                                                                                                                  <NA>
#> 103                                                              Department of Ecology and Evolutionary Biology, Tulane University, New Orleans, LA, USA.
#> 104                                                                                                                             https://ror.org/04vmvtb21
#> 105                                                                                                                                       Timothée Poisot
#> 106                                                                                                                                                Poisot
#> 107                                                                                                                                             Timothée 
#> 108                                                                                                                 https://orcid.org/0000-0002-0735-5184
#> 109                                                                    Département de Sciences Biologiques, Université de Montréal, Montreal, QC, Canada.
#> 110                                                                                                                             https://ror.org/0161xgx34
#> 111                                                                                                                                      Hailey Robertson
#> 112                                                                                                                                             Robertson
#> 113                                                                                                                                               Hailey 
#> 114                                                                                                                 https://orcid.org/0009-0007-2988-307X
#> 115                                                                Department of Epidemiology of Microbial Diseases, Yale University, New Haven, CT, USA.
#> 116                                                                                                                             https://ror.org/03v76x132
#> 117                                                                                                                                          Sadie J Ryan
#> 118                                                                                                                                                  Ryan
#> 119                                                                                                                                              Sadie J 
#> 120                                                                                                                 https://orcid.org/0000-0002-4308-6321
#> 121                                                                            Emerging Pathogens Institute, University of Florida, Gainesville, FL, USA.
#> 122                                                                                                                             https://ror.org/02y3ad647
#> 123                                                                                                                                   Stephanie N Seifert
#> 124                                                                                                                                               Seifert
#> 125                                                                                                                                          Stephanie N 
#> 126                                                                                                                 https://orcid.org/0000-0002-4397-6156
#> 127                                                                   Paul G. Allen School for Global Health, University of Washington, Pullman, WA, USA.
#> 128                                                                                                                             https://ror.org/00cvxb145
#> 129                                                                                                                                          David Simons
#> 130                                                                                                                                                Simons
#> 131                                                                                                                                                David 
#> 132                                                                                                                                                  <NA>
#> 133                                                                    Department of Anthropology, Pennsylvania State University, State College, PA, USA.
#> 134                                                                                                                             https://ror.org/04p491231
#> 135                                                                                                                                 Amanda Vicente-Santos
#> 136                                                                                                                                        Vicente-Santos
#> 137                                                                                                                                               Amanda 
#> 138                                                                                                                 https://orcid.org/0000-0001-6012-2059
#> 139                                                                               School of Biological Sciences, University of Oklahoma, Norman, OK, USA.
#> 140                                                                                                                             https://ror.org/02aqsxs83
#> 141                                                                                                                                        Chelsea L Wood
#> 142                                                                                                                                                  Wood
#> 143                                                                                                                                            Chelsea L 
#> 144                                                                                                                 https://orcid.org/0000-0003-2738-3139
#> 145                                                                   School of Aquatic and Fishery Sciences, University of Washington, Seattle, WA, USA.
#> 146                                                                                                                             https://ror.org/00cvxb145
#> 147                                                                                                                                         Ellie Graeden
#> 148                                                                                                                                               Graeden
#> 149                                                                                                                                                Ellie 
#> 150                                                                                                                 https://orcid.org/0000-0002-1265-9756
#> 151                                                                                   Massive Data Institute, Georgetown University, Washington, DC, USA.
#> 152                                                                                                                             https://ror.org/05vzafd60
#> 153                                                                                                                                       Colin J Carlson
#> 154                                                                                                                                               Carlson
#> 155                                                                                                                                              Colin J 
#> 156                                                                                                                 https://orcid.org/0000-0001-6960-8434
#> 157                                        Department of Epidemiology of Microbial Diseases, Yale University, New Haven, CT, USA. colin.carlson@yale.edu.
#> 158                                                                                                                             https://ror.org/03v76x132
#> 159                                                                                A minimum data standard for wildlife disease research and surveillance
#> 160                                                                                                                                                  2025
#> 161                                                                                                                                                    en
#> 162                                                                                                                                            FILL ME IN
#> 163                                                                                                                                              abstract
#> 164                                                                                                                           National Science Foundation
#> 165                                                                                                                             https://ror.org/021nxhr62
#> 166                                                                                                                                               2213854
#> 167                                                                                                                                                      
#> 168                                                                                                                                                      
#> 169                                                                                                                           National Science Foundation
#> 170                                                                                                                             https://ror.org/021nxhr62
#> 171                                                                                                                                               2213854
#> 172                                                                                                                                                      
#> 173                                                                                                                                                      
#> 174                                                                                                                           National Science Foundation
#> 175                                                                                                                             https://ror.org/021nxhr62
#> 176                                                                                                                                               2213854
#> 177                                                                                                                                                      
#> 178                                                                                                                                                      
#> 179                                                                                                                           National Science Foundation
#> 180                                                                                                                             https://ror.org/021nxhr62
#> 181                                                                                                                                               2213854
#> 182                                                                                                                                                      
#> 183                                                                                                                                                      
#> 184                                                                                                                           National Science Foundation
#> 185                                                                                                                             https://ror.org/021nxhr62
#> 186                                                                                                                                               2213854
#> 187                                                                                                                                                      
#> 188                                                                                                                                                      
#> 189                                                                                                                           National Science Foundation
#> 190                                                                                                                             https://ror.org/021nxhr62
#> 191                                                                                                                                               2213854
#> 192                                                                                                                                                      
#> 193                                                                                                                                                      
#> 194                                                                                                                           National Science Foundation
#> 195                                                                                                                             https://ror.org/021nxhr62
#> 196                                                                                                                                               2213854
#> 197                                                                                                                                                      
#> 198                                                                                                                                                      
#> 199                                                                                                                           National Science Foundation
#> 200                                                                                                                             https://ror.org/021nxhr62
#> 201                                                                                                                                               2213854
#> 202                                                                                                                                                      
#> 203                                                                                                                                                      
#> 204                                                                                                                           National Science Foundation
#> 205                                                                                                                             https://ror.org/021nxhr62
#> 206                                                                                                                                               2213854
#> 207                                                                                                                                                      
#> 208                                                                                                                                                      
#> 209                                                                                                                           National Science Foundation
#> 210                                                                                                                             https://ror.org/021nxhr62
#> 211                                                                                                                                               2213854
#> 212                                                                                                                                                      
#> 213                                                                                                                                                      
#> 214                                                                                                                           National Science Foundation
#> 215                                                                                                                             https://ror.org/021nxhr62
#> 216                                                                                                                                               2213854
#> 217                                                                                                                                                      
#> 218                                                                                                                                                      
#> 219                                                                                                                           National Science Foundation
#> 220                                                                                                                             https://ror.org/021nxhr62
#> 221                                                                                                                                               2213854
#> 222                                                                                                                                                      
#> 223                                                                                                                                                      
#> 224                                                                                                                           National Science Foundation
#> 225                                                                                                                             https://ror.org/021nxhr62
#> 226                                                                                                                                               2213854
#> 227                                                                                                                                                      
#> 228                                                                                                                                                      
#> 229                                                                                                                           National Science Foundation
#> 230                                                                                                                             https://ror.org/021nxhr62
#> 231                                                                                                                                               2213854
#> 232                                                                                                                                                      
#> 233                                                                                                                                                      
#> 234                                                                                                                           National Science Foundation
#> 235                                                                                                                             https://ror.org/021nxhr62
#> 236                                                                                                                                               2213854
#> 237                                                                                                                                                      
#> 238                                                                                                                                                      
#> 239                                                                                                                           National Science Foundation
#> 240                                                                                                                             https://ror.org/021nxhr62
#> 241                                                                                                                                               2515340
#> 242                                                                                                                                                      
#> 243                                                                                                                                                      
#> 244                                                                                                                           National Science Foundation
#> 245                                                                                                                             https://ror.org/021nxhr62
#> 246                                                                                                                                               2515340
#> 247                                                                                                                                                      
#> 248                                                                                                                                                      
#> 249                                                                                                                                              Metadata
#> 250                                                                                                                                              Wildlife
#> 251                                                                                                                                          Data sharing
#> 252                                                                                                                                      Wildlife disease
#> 253                                                                                                                                      Computer science
#> 254                                                                                                                               Transparency (behavior)
#> 255                                                                                                                                         Best practice
#> 256                                                                                                                                          Data science
#> 257                                                                                                                                      Table (database)
#> 258                                                                                                                                          Data element
#> 259                                                                                                                                           Data mining
#> 260                                                                                                                                 Information retrieval
#> 261                                                                                                                                        World Wide Web
#> 262                                                                                                                                               Ecology
#> 263                                                                                                                                               Biology
#> 264                                                                                                                                              Medicine
#> 265                                                                                                                         A valid Identifier like a DOI
#> 266    see accepted values here https://datacite-metadata-schema.readthedocs.io/en/4.5/appendices/appendix-1/relatedIdentifierType/#relatedidentifiertype
#> 267                     see accepted values here: https://datacite-metadata-schema.readthedocs.io/en/4.5/appendices/appendix-1/relationType/#relationtype
```
