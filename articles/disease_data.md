# Wildlife Disease Data

``` r
library(wddsWizard)
library(dplyr)
library(readxl)
library(janitor)
library(jsonlite)
```

The Wildlife Disease Data Standard is composed of two components -
disease data and project metadata. Standardizing how disease data are
stored is the primary goal of WDDS.

This vignette describes how to prepare data for validation against the
wildlife disease data standard. We will 1) read an example excel
spreadsheet, 2) do some light reformatting, and 3) produce a json
object.

## Required fields

The following fields are required to be in the data.

| Field                                                                 | Descriptions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|:----------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sampleID                                                              | A researcher-generated unique ID for the sample: usually a unique string of both characters and integers (e.g., OS BZ19-114 to indicate an oral swab taken from animal BZ19-114; see worked example below), to avoid conflicts that can arise when datasets are merged with number-only notation for samples. Ideally, sample names should be kept consistent across all online databases and physical resources (e.g., museum collections or project-specific sample archives).                                                                                                                                                                                                                                                      |
| [latitude](http://rs.tdwg.org/dwc/terms/decimalLatitude)              | Latitude of the collection site in decimal format.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| [longitude](http://rs.tdwg.org/dwc/terms/decimalLongitude)            | Longitude of the collection site in decimal format.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| sampleCollectionMethod                                                | The technique used to acquire the sample and/or the tissue from which the sample was acquired (e.g. visual inspection; swab; wing punch; necropsy).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| [hostIdentification](http://rs.tdwg.org/dwc/terms/scientificName)     | The Linnaean classification of the animal from which the sample was collected, reported at the lowest possible level (ideally, species binomial name: e.g., Odocoileus virginianus or Ixodes scapularis). As necessary, researchers may also include an additional field indicating when uncertainty exists in the identification of the host organism (see Adding new fields).                                                                                                                                                                                                                                                                                                                                                       |
| [detectionTarget](http://rs.tdwg.org/dwc/terms/associatedOccurrences) | The taxonomic identity of the parasite being screened for in the sample. This will often be coarser than the identity of a specific parasite identified in the sample: for example, in a study screening for novel bat coronaviruses, the entire family Coronaviridae might be the target; in a parasite dissection, the targets might be Acanthocephala, Cestoda, Nematoda, and Trematoda. For deep sequencing approaches (e.g., metagenomic and metatranscriptomic viral discovery), researchers should report each alignment target used as a new test to maximize reporting of negative data, or alternatively, select a subset that reflect specific study objectives and the focus of analysis (e.g., specific viral families). |
| detectionMethod                                                       | The type of test performed to detect the parasite or parasite-specific antibody (e.g., ‘qPCR’, ‘ELISA’)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| [detectionOutcome](http://rs.tdwg.org/dwc/terms/occurrenceStatus)     | The test result (i.e., positive, negative, or inconclusive). To avoid ambiguity, these specific values are suggested over numeric values (0 or 1).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| parasiteIdentification                                                | The identity of a parasite detected by the test, if any, reported to the lowest possible taxonomic level, either as a Linnaean binomial classification or within the convention of a relevant taxonomic authority (e.g., Borrelia burgdorferi or Zika virus). Parasite identification may be more specific than detection target.                                                                                                                                                                                                                                                                                                                                                                                                     |

## Read in and Clean up the excel spreadsheet

``` r
## read
becker_data <- wdds_example_data(version = "latest", file = "Becker_demo_dataset.xlsx") |>
  readxl::read_xlsx()

becker_data_prelim <- janitor::clean_names(becker_data, case = "lower_camel")
```

### Check for required Fields

``` r
# check that required fields are in dataset
required_field_check <- wddsWizard::disease_data_required_fields %in% names(becker_data_prelim)

wddsWizard::disease_data_required_fields[!required_field_check]
#> [1] "sampleID"               "sampleCollectionMethod"
```

### Rename Fields to match standard

``` r
becker_data_prelim$collectionMethod
#> [1] "Oral swab"   "Rectal swab"

becker_data_clean <- becker_data_prelim |>
  dplyr::rename(
    "sampleID" = "sampleId",
    "animalID" = "animalId",
    "collectionMethodAndOrTissue" = "collectionMethod"
  )

# check that all required fields are in the data
all(wddsWizard::disease_data_required_fields %in% names(becker_data_clean))
#> [1] FALSE
```

## Prep for JSON

``` r
becker_prepped <- prep_data(becker_data_clean)

## wrap the prepped data in list
becker_data_json <- becker_prepped |>
  jsonlite::toJSON(pretty = TRUE)
```

## Validate disease data

``` r
## get the schema -- notice that you can set the version of the schema
schema <- wdds_json(version = "latest", file = "schemas/disease_data.json")

dd_validator <- jsonvalidate::json_validator(schema, engine = "ajv")

dd_validation <- dd_validator(becker_data_json, verbose = TRUE)

## check for errors!

errors <- attributes(dd_validation)

if (!dd_validation) {
  errors$errors
} else {
  print("Valid project metadata!😁")
}
#>   instancePath schemaPath  keyword        missingProperty
#> 1              #/required required sampleCollectionMethod
#>                                                message
#> 1 must have required property 'sampleCollectionMethod'
#>                                                                                                                                                  schema
#> 1 sampleID, latitude, longitude, sampleCollectionMethod, hostIdentification, detectionTarget, detectionMethod, detectionOutcome, parasiteIdentification
#>                           parentSchema.$schema    parentSchema.title
#> 1 https://json-schema.org/draft/2020-12/schema Wildlife Disease Data
#>                                                         parentSchema.description
#> 1 Schema for Wildlife Disease Data. This a general and extensible data standard.
#>   parentSchema.type
#> 1            object
#>                                                                                                                                                                                                                                                                                                                                                                                                                                       parentSchema.properties.sampleID.description
#> 1 A researcher-generated unique ID for the sample: usually a unique string of both characters and integers (e.g., OS BZ19-114 to indicate an oral swab taken from animal BZ19-114; see worked example below), to avoid conflicts that can arise when datasets are merged with number-only notation for samples. Ideally, sample names should be kept consistent across all online databases and physical resources (e.g., museum collections or project-specific sample archives).
#>   parentSchema.properties.sampleID.type
#> 1                                 array
#>   parentSchema.properties.sampleID.items.type
#> 1                                string, null
#>   parentSchema.properties.sampleID.items.minItems
#> 1                                               1
#>                                                                                                                                                                                                                                                                                       parentSchema.properties.animalID.description
#> 1 A researcher-generated unique ID for the individual animal from which the sample was collected: usually a unique string of both characters and integers (e.g., BZ19-114 to indicate animal 114 sampled in 2019 in Belize). Ideally, animal names should again be kept consistent across online databases and physical resources.
#>   parentSchema.properties.animalID.type
#> 1                                 array
#>   parentSchema.properties.animalID.items.type
#> 1                                string, null
#>   parentSchema.properties.animalID.items.minItems
#> 1                                               1
#>                                                          parentSchema.properties.latitude.description
#> 1 Latitude of the collection site in decimal format. See http://rs.tdwg.org/dwc/terms/decimalLatitude
#>   parentSchema.properties.latitude.type
#> 1                                 array
#>   parentSchema.properties.latitude.items.type
#> 1                                number, null
#>   parentSchema.properties.latitude.items.minItems
#> 1                                               1
#>   parentSchema.properties.latitude.items.maximum
#> 1                                             90
#>   parentSchema.properties.latitude.items.minimum
#> 1                                            -90
#>                                                            parentSchema.properties.longitude.description
#> 1 Longitude of the collection site  in decimal format. See http://rs.tdwg.org/dwc/terms/decimalLongitude
#>   parentSchema.properties.longitude.type
#> 1                                  array
#>   parentSchema.properties.longitude.items.type
#> 1                                 number, null
#>   parentSchema.properties.longitude.items.minItems
#> 1                                                1
#>   parentSchema.properties.longitude.items.maximum
#> 1                                             180
#>   parentSchema.properties.longitude.items.minimum
#> 1                                            -180
#>                                                                                                                                                           parentSchema.properties.spatialUncertainty.description
#> 1 Coordinate uncertainty from GPS recordings, post-hoc digitization, or systematic alterations (e.g., jittering or rounding) expressed in meters. See http://rs.tdwg.org/dwc/terms/coordinateUncertaintyInMeters
#>   parentSchema.properties.spatialUncertainty.type
#> 1                                           array
#>   parentSchema.properties.spatialUncertainty.items.type
#> 1                                          number, null
#>   parentSchema.properties.spatialUncertainty.items.minItems
#> 1                                                         1
#>   parentSchema.properties.spatialUncertainty.items.minimum
#> 1                                                        0
#>                                                parentSchema.properties.collectionDay.description
#> 1 The day of the month on which the specimen was collected. See http://rs.tdwg.org/dwc/terms/day
#>   parentSchema.properties.collectionDay.type
#> 1                                      array
#>   parentSchema.properties.collectionDay.items.type
#> 1                                    integer, null
#>   parentSchema.properties.collectionDay.items.minItems
#> 1                                                    1
#>   parentSchema.properties.collectionDay.items.minimum
#> 1                                                   1
#>   parentSchema.properties.collectionDay.items.maximum
#> 1                                                  31
#>                                     parentSchema.properties.collectionMonth.description
#> 1 The month in which the specimen was collected. See http://rs.tdwg.org/dwc/terms/month
#>   parentSchema.properties.collectionMonth.type
#> 1                                        array
#>   parentSchema.properties.collectionMonth.items.type
#> 1                                      integer, null
#>   parentSchema.properties.collectionMonth.items.minItems
#> 1                                                      1
#>   parentSchema.properties.collectionMonth.items.minimum
#> 1                                                     1
#>   parentSchema.properties.collectionMonth.items.maximum
#> 1                                                    12
#>                                    parentSchema.properties.collectionYear.description
#> 1 The year in which the specimen was collected. See http://rs.tdwg.org/dwc/terms/year
#>   parentSchema.properties.collectionYear.type
#> 1                                       array
#>   parentSchema.properties.collectionYear.type
#> 1                               integer, null
#>                                                                                            parentSchema.properties.sampleCollectionMethod.description
#> 1 The technique used to acquire the sample and/or the tissue from which the sample was acquired (e.g. visual inspection; swab; wing punch; necropsy).
#>   parentSchema.properties.sampleCollectionMethod.examples
#> 1           visual inspection, swab, wing punch, necropsy
#>   parentSchema.properties.sampleCollectionMethod.type
#> 1                                               array
#>   parentSchema.properties.sampleCollectionMethod.items.type
#> 1                                                    string
#>   parentSchema.properties.sampleCollectionMethod.items.minItems
#> 1                                                             1
#>                                            parentSchema.properties.sampleMaterial.description
#> 1 Organic tissue or fluid being collected (e.g., “liver”; “blood”; “skin”; “whole organism”).
#>   parentSchema.properties.sampleMaterial.examples
#> 1              liver, blood, skin, whole organism
#>   parentSchema.properties.sampleMaterial.type
#> 1                                       array
#>   parentSchema.properties.sampleMaterial.items.type
#> 1                                      string, null
#>   parentSchema.properties.sampleMaterial.items.minItems
#> 1                                                     1
#>                                     parentSchema.properties.sampleCollectionBodyPart.description
#> 1 Part of the animal body that samples are generated or collected from (e.g., “rectum”; “wing”).
#>   parentSchema.properties.sampleCollectionBodyPart.examples
#> 1                                              rectum, wing
#>   parentSchema.properties.sampleCollectionBodyPart.type
#> 1                                                 array
#>   parentSchema.properties.sampleCollectionBodyPart.items.type
#> 1                                                string, null
#>   parentSchema.properties.sampleCollectionBodyPart.items.minItems
#> 1                                                               1
#>                                                                                                                                                                                                                                                                                                                                                                            parentSchema.properties.hostIdentification.description
#> 1 The Linnaean classification of the animal from which the sample was collected, reported at the lowest possible level (ideally, species binomial name: e.g., Odocoileus virginianus or Ixodes scapularis). As necessary, researchers may also include an additional field indicating when uncertainty exists in the identification of the host organism (see Adding new fields). See http://rs.tdwg.org/dwc/terms/scientificName
#>   parentSchema.properties.hostIdentification.type
#> 1                                           array
#>   parentSchema.properties.hostIdentification.items.type
#> 1                                          string, null
#>   parentSchema.properties.hostIdentification.items.minItems
#> 1                                                         1
#>   parentSchema.properties.hostIdentification.items.pattern
#> 1                        [HOMOhomo]{4} [SAPIENSsapiens]{7}
#>                                                              parentSchema.properties.organismSex.description
#> 1 The sex of the individual animal from which the sample was collected. See http://rs.tdwg.org/dwc/terms/sex
#>   parentSchema.properties.organismSex.examples
#> 1                  male, female, hermaphrodite
#>   parentSchema.properties.organismSex.type
#> 1                                    array
#>   parentSchema.properties.organismSex.items.type
#> 1                                   string, null
#>   parentSchema.properties.organismSex.items.minItems
#> 1                                                  1
#>                                                                                                                                                                                        parentSchema.properties.liveCapture.description
#> 1 Whether the individual animal from which the sample was collected was alive at the time of capture. Should be TRUE or FALSE; lethal sampling should be recorded as TRUE as this field describes the organism at the time of capture.
#>   parentSchema.properties.liveCapture.type
#> 1                                    array
#>   parentSchema.properties.liveCapture.items.type
#> 1                                  boolean, null
#>   parentSchema.properties.liveCapture.items.minItems
#> 1                                                  1
#>                                                                                                                        parentSchema.properties.hostLifeStage.description
#> 1 The life stage of the animal from which the sample was collected (as appropriate for the organism) (e.g., juvenile, adult). See http://rs.tdwg.org/dwc/terms/lifeStage
#>   parentSchema.properties.hostLifeStage.examples
#> 1                         juvenile, adult, larva
#>   parentSchema.properties.hostLifeStage.type
#> 1                                      array
#>   parentSchema.properties.hostLifeStage.items.type
#> 1                                     string, null
#>   parentSchema.properties.hostLifeStage.items.minItems
#> 1                                                    1
#>                                                                                                           parentSchema.properties.age.description
#> 1 The numeric age of the animal from which the sample was collected, at the time of sample collection, if known (e.g., in monitored populations).
#>   parentSchema.properties.age.type parentSchema.properties.age.items.type
#> 1                            array                           number, null
#>   parentSchema.properties.age.items.minItems
#> 1                                          1
#>   parentSchema.properties.age.items.minimum
#> 1                                         0
#>          parentSchema.properties.ageUnits.description
#> 1 The units in which age is measured (usually years).
#>   parentSchema.properties.ageUnits.type
#> 1                                 array
#>   parentSchema.properties.ageUnits.items.type
#> 1                                string, null
#>        parentSchema.properties.ageUnits.items.enum
#> 1 years, months, days, hours, minutes, seconds, NA
#>   parentSchema.properties.ageUnits.items.minItems
#> 1                                               1
#>                                                        parentSchema.properties.mass.description
#> 1 The mass of the animal from which the sample was collected, at the time of sample collection.
#>   parentSchema.properties.mass.type parentSchema.properties.mass.items.type
#> 1                             array                            number, null
#>   parentSchema.properties.mass.items.minItems
#> 1                                           1
#>   parentSchema.properties.mass.items.minimum
#> 1                                          0
#>    parentSchema.properties.massUnits.description
#> 1 The units that mass is recorded in (e.g., kg).
#>   parentSchema.properties.massUnits.examples
#> 1             kg, g, mg, kilogram, milligram
#>   parentSchema.properties.massUnits.type
#> 1                                  array
#>   parentSchema.properties.massUnits.items.type
#> 1                                 string, null
#>   parentSchema.properties.massUnits.items.minItems
#> 1                                                1
#>                                                                parentSchema.properties.length.description
#> 1 The numeric length of the animal from which the sample was collected, at the time of sample collection.
#>   parentSchema.properties.length.type parentSchema.properties.length.items.type
#> 1                               array                              number, null
#>   parentSchema.properties.length.items.minItems
#> 1                                             1
#>   parentSchema.properties.length.items.minimum
#> 1                                            0
#>                                                                          parentSchema.properties.lengthMeasurement.description
#> 1 The axis of measurement for the organism being measured (e.g., snout-vent length or just SVL; wing length; primary feather).
#>          parentSchema.properties.lengthMeasurement.examples
#> 1 snout-vent length, intertegular distance, primary feather
#>   parentSchema.properties.lengthMeasurement.type
#> 1                                          array
#>   parentSchema.properties.lengthMeasurement.items.type
#> 1                                         string, null
#>   parentSchema.properties.lengthMeasurement.items.minItems
#> 1                                                        1
#>        parentSchema.properties.lengthUnits.description
#> 1 The units that length is recorded in (e.g., meters).
#>   parentSchema.properties.lengthUnits.examples
#> 1                           mm, meters, cm, km
#>   parentSchema.properties.lengthUnits.type
#> 1                                    array
#>   parentSchema.properties.lengthUnits.items.type
#> 1                                   string, null
#>   parentSchema.properties.lengthUnits.items.minItems
#> 1                                                  1
#>                                                             parentSchema.properties.organismQuantity.description
#> 1 A number or enumeration value for the quantity of organisms. See http://rs.tdwg.org/dwc/terms/organismQuantity
#>   parentSchema.properties.organismQuantity.examples
#> 1                                    1.0, 1.4, 12.0
#>   parentSchema.properties.organismQuantity.type
#> 1                                         array
#>   parentSchema.properties.organismQuantity.items.type
#> 1                                        number, null
#>   parentSchema.properties.organismQuantity.items.minItems
#> 1                                                       1
#>   parentSchema.properties.organismQuantity.items.minimum
#> 1                                                      0
#>                                                                   parentSchema.properties.organismQuantityUnits.description
#> 1 The units that organism quantity is recorded in (e.g. “individuals”). See http://rs.tdwg.org/dwc/iri/organismQuantityType
#>   parentSchema.properties.organismQuantityUnits.examples
#> 1              individual, biomass, Braun-Blanquet scale
#>   parentSchema.properties.organismQuantityUnits.type
#> 1                                              array
#>   parentSchema.properties.organismQuantityUnits.items.type
#> 1                                             string, null
#>   parentSchema.properties.organismQuantityUnits.items.minItems
#> 1                                                            1
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            parentSchema.properties.detectionTarget.description
#> 1 The taxonomic identity of the parasite being screened for in the sample. This will often be coarser than the identity of a specific parasite identified in the sample: for example, in a study screening for novel bat coronaviruses, the entire family Coronaviridae might be the target; in a parasite dissection, the targets might be Acanthocephala, Cestoda, Nematoda, and Trematoda. For deep sequencing approaches (e.g., metagenomic and metatranscriptomic viral discovery), researchers should report each alignment target used as a new test to maximize reporting of negative data, or alternatively, select a subset that reflect specific study objectives and the focus of analysis (e.g., specific viral families). See http://rs.tdwg.org/dwc/terms/associatedOccurrences
#>   parentSchema.properties.detectionTarget.type
#> 1                                        array
#>   parentSchema.properties.detectionTarget.items.type
#> 1                                       string, null
#>   parentSchema.properties.detectionTarget.items.minItems
#> 1                                                      1
#>                                                       parentSchema.properties.detectionMethod.description
#> 1 The type of test performed to detect the parasite or parasite-specific antibody (e.g., 'qPCR', ‘ELISA’)
#>   parentSchema.properties.detectionMethod.type
#> 1                                        array
#>   parentSchema.properties.detectionMethod.items.type
#> 1                                       string, null
#>   parentSchema.properties.detectionMethod.items.minItems
#> 1                                                      1
#>                                                                                                                               parentSchema.properties.forwardPrimerSequence.description
#> 1 The sequence of the forward primer used for parasite detection (e.g., for a pan-coronavirus primer: 5’ CDCAYGARTTYTGYTCNCARC 3'). (Strongly encouraged if applicable, e.g., for PCR.)
#>   parentSchema.properties.forwardPrimerSequence.examples
#> 1                            5’ CDCAYGARTTYTGYTCNCARC 3'
#>   parentSchema.properties.forwardPrimerSequence.type
#> 1                                              array
#>   parentSchema.properties.forwardPrimerSequence.items.type
#> 1                                             string, null
#>   parentSchema.properties.forwardPrimerSequence.items.minItems
#> 1                                                            1
#>                                                                                               parentSchema.properties.reversePrimerSequence.description
#> 1 The sequence of the reverse primer used for parasite detection (e.g., 5’ RHGGRTANGCRTCWATDGC 3'). (Strongly encouraged if applicable, e.g., for PCR.)
#>   parentSchema.properties.reversePrimerSequence.examples
#> 1                              5’ RHGGRTANGCRTCWATDGC 3'
#>   parentSchema.properties.reversePrimerSequence.type
#> 1                                              array
#>   parentSchema.properties.reversePrimerSequence.items.type
#> 1                                             string, null
#>   parentSchema.properties.reversePrimerSequence.items.minItems
#> 1                                                            1
#>                     parentSchema.properties.geneTarget.description
#> 1 The parasite gene targeted by the primer (e.g. “RdRp” for PCR.).
#>   parentSchema.properties.geneTarget.examples
#> 1                                        RdRp
#>   parentSchema.properties.geneTarget.type
#> 1                                   array
#>   parentSchema.properties.geneTarget.items.type
#> 1                                  string, null
#>   parentSchema.properties.geneTarget.items.minItems
#> 1                                                 1
#>                                                   parentSchema.properties.primerCitation.description
#> 1 Citation(s) for the primer(s) (ideally doi, or other permanent identifier for a work, e.g. PMID). 
#>                                                                                                                                                                                                                                      parentSchema.properties.primerCitation.examples
#> 1 https://doi.org/10.1016/j.virol.2007.06.009, Complete genome sequence of bat coronavirus HKU2 from Chinese horseshoe bats revealed a much smaller spike gene with a different evolutionary lineage from the rest of the genome, PMC7103351, https://openalex.org/works/w2036144053
#>   parentSchema.properties.primerCitation.type
#> 1                                       array
#>   parentSchema.properties.primerCitation.items.type
#> 1                                      string, null
#>   parentSchema.properties.primerCitation.items.minItems
#> 1                                                     1
#>                                                     parentSchema.properties.probeTarget.description
#> 1 Antibody or antigen targeted for detection. (Strongly encouraged if applicable, e.g., for ELISA.)
#>   parentSchema.properties.probeTarget.type
#> 1                                    array
#>   parentSchema.properties.probeTarget.items.type
#> 1                                   string, null
#>   parentSchema.properties.probeTarget.items.minItems
#> 1                                                  1
#>                                                   parentSchema.properties.probeType.description
#> 1 Antibody or antigen used for detection. (Strongly encouraged if applicable, e.g., for ELISA.)
#>   parentSchema.properties.probeType.type
#> 1                                  array
#>   parentSchema.properties.probeType.items.type
#> 1                                 string, null
#>   parentSchema.properties.probeType.items.minItems
#> 1                                                1
#>                                                   parentSchema.properties.probeCitation.description
#> 1 Citation(s) for the probe(s) (ideally doi, or other permanent identifier for a work, e.g. PMID). 
#>   parentSchema.properties.probeCitation.type
#> 1                                      array
#>   parentSchema.properties.probeCitation.items.type
#> 1                                     string, null
#>   parentSchema.properties.probeCitation.items.minItems
#> 1                                                    1
#>                                                                                                                                                   parentSchema.properties.detectionOutcome.description
#> 1 The test result (i.e., positive, negative, or inconclusive). To avoid ambiguity, these specific values are suggested over numeric values (0 or 1). See http://rs.tdwg.org/dwc/terms/occurrenceStatus
#>   parentSchema.properties.detectionOutcome.type
#> 1                                         array
#>   parentSchema.properties.detectionOutcome.items.type
#> 1                                        string, null
#>   parentSchema.properties.detectionOutcome.items.minItems
#> 1                                                       1
#>                                                                                                             parentSchema.properties.detectionMeasurement.description
#> 1 Any numeric measurement of parasite detection that is more detailed than simple positive or negative results (e.g., viral titer, parasite counts, sequence reads).
#>   parentSchema.properties.detectionMeasurement.type
#> 1                                             array
#>   parentSchema.properties.detectionMeasurement.items.type
#> 1                                            number, null
#>   parentSchema.properties.detectionMeasurement.items.minItems
#> 1                                                           1
#>                                                         parentSchema.properties.detectionMeasurementUnits.description
#> 1 Units for quantitative measurements of parasite intensity or test results (e.g., Ct, TCID50/mL, or parasite count).
#>   parentSchema.properties.detectionMeasurementUnits.examples
#> 1                              Ct, TCID50/mL, parasite count
#>   parentSchema.properties.detectionMeasurementUnits.type
#> 1                                                  array
#>   parentSchema.properties.detectionMeasurementUnits.items.type
#> 1                                                 string, null
#>   parentSchema.properties.detectionMeasurementUnits.items.minItems
#> 1                                                                1
#>                                                                                                                                                                                                                                                                          parentSchema.properties.parasiteIdentification.description
#> 1 The identity of a parasite detected by the test, if any, reported to the lowest possible taxonomic level, either as a Linnaean binomial classification or within the convention of a relevant taxonomic authority (e.g., Borrelia burgdorferi or Zika virus). Parasite identification may be more specific than detection target.
#>   parentSchema.properties.parasiteIdentification.examples
#> 1   Zika virus, Borrelia burgdorferi, Onchocerca volvulus
#>   parentSchema.properties.parasiteIdentification.type
#> 1                                               array
#>   parentSchema.properties.parasiteIdentification.items.type
#> 1                                              string, null
#>   parentSchema.properties.parasiteIdentification.items.minItems
#> 1                                                             1
#>                                                                                                                                                                                                parentSchema.properties.parasiteID.description
#> 1 A researcher-generated unique ID for an individual parasite (primarily useful in nested cases where this ID is used as an animal ID in another row, such as pathogen  testing of a blood-feeding arthropod removed from a vertebrate host).
#>   parentSchema.properties.parasiteID.examples
#> 1                             001, TICK201923
#>   parentSchema.properties.parasiteID.type
#> 1                                   array
#>   parentSchema.properties.parasiteID.items.type
#> 1                                  string, null
#>   parentSchema.properties.parasiteID.items.minItems
#> 1                                                 1
#>                                                                           parentSchema.properties.parasiteLifeStage.description
#> 1 The life stage of the parasite from which the sample was collected (as appropriate for the organism) (e.g., juvenile, adult).
#>   parentSchema.properties.parasiteLifeStage.examples
#> 1                        juvenile, adult, sporozoite
#>   parentSchema.properties.parasiteLifeStage.type
#> 1                                          array
#>   parentSchema.properties.parasiteLifeStage.items.type
#> 1                                         string, null
#>   parentSchema.properties.parasiteLifeStage.items.minItems
#> 1                                                        1
#>                                                                                                                                                                                                                                                     parentSchema.properties.genbankAccession.description
#> 1 The GenBank accession for any parasite genetic sequence(s), if appropriate.  Accession numbers or other identifiers for related data stored on another platform should be added in a different field (e.g. GISAID Accession, Immport Accession). See http://rs.tdwg.org/dwc/terms/otherCatalogNumbers 
#>   parentSchema.properties.genbankAccession.examples
#> 1                           U49845 | U49846, U11111
#>   parentSchema.properties.genbankAccession.type
#> 1                                         array
#>   parentSchema.properties.genbankAccession.items.type
#> 1                                        string, null
#>   parentSchema.properties.genbankAccession.items.minItems
#> 1                                                       1
#>                                                                                                                                   parentSchema.required
#> 1 sampleID, latitude, longitude, sampleCollectionMethod, hostIdentification, detectionTarget, detectionMethod, detectionOutcome, parasiteIdentification
#>   parentSchema.dependentRequired.mass parentSchema.dependentRequired.length
#> 1                           massUnits        lengthUnits, lengthMeasurement
#>   parentSchema.dependentRequired.organismQuantity
#> 1                           organismQuantityUnits
#>   parentSchema.dependentRequired.detectionMeasurement          data.sampleID
#> 1                           detectionMeasurementUnits OS BZ19-95, RS BZ19-95
#>        data.animalID    data.latitude     data.longitude data.collectionDay
#> 1 BZ19-114, BZ19-114 17.7643, 17.7643 -88.6521, -88.6521             23, 23
#>   data.collectionMonth data.collectionYear data.collectionMethodAndOrTissue
#> 1                 4, 4          2019, 2019           Oral swab, Rectal swab
#>                data.hostIdentification data.organismSex data.deadOrAlive
#> 1 Desmodus rotundus, Desmodus rotundus       male, male     alive, alive
#>   data.hostLifeStage    data.mass data.massUnits         data.detectionTarget
#> 1 subadult, subadult 0.023, 0.023         kg, kg Coronaviridae, Coronaviridae
#>               data.detectionMethod data.primerSequence
#> 1 semi-nested PCR, semi-nested PCR          RdRp, RdRp
#>                          data.primerCitation data.detectionOutcome
#> 1 doi:10.3390/v9120364, doi:10.3390/v9120364    positive, negative
#>   data.parasiteIdentification data.genBankAccession dataPath
#> 1        Alphacoronavirus, NA          OM240578, NA
```
