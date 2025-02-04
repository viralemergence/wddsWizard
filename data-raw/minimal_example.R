## code to prepare `minimal_dataset` dataset goes here

minimal_dataset <- jsonlite::fromJSON(txt = '{

  "animalID":["d","e","f"],
  "sampleID":["a","b","c"],
  "latitude":[1,2,3],
  "longitude":[1,2,null],
  "collectionDay":[1,1,1],
  "collectionMonth":[12,10,1],
  "collectionYear":[1,2024,2025],
  "collectionMethodAndOrTissue":["Oral Swab","rectal swab","blood draw"],
  "hostIdentification":["Panthera leo","Connochaetes taurinus","Numida meleagris"],
  "detectionTarget":["Coronaviridae","Coronaviridae","Coronaviridae"],
  "detectionMethod":["rt-PCR","rt-PCR","rt-PCR"] ,
  "detectionOutcome":["positive","negative","inconclusive"],
  "parasiteIdentification":["sars-cov-2",null,null]
    }') |>
  as.data.frame()

usethis::use_data(minimal_dataset, overwrite = TRUE)

project_metadata_json <- '{
"creators":[{
  "name":"Creadora, Mimi"
}
],
"methodology":{
  "eventBased":true
},
"titles":[
  {
    "title": "some title"
  }
],
"publicationYear":"1988",
"description":[
  {
    "description":"my great abstract"
  }
],
"language":"English",
"fundingReferences":[
  {
    "funderName":"Some Funder"
  }
]
}'

minimal_project_metadata <- jsonlite::fromJSON(project_metadata_json,simplifyVector = TRUE)

# jsonlite::toJSON(minimal_project_metadata,pretty = TRUE,auto_unbox = TRUE)

usethis::use_data(minimal_project_metadata, overwrite = TRUE)
