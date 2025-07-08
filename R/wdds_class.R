### use this object for managing interactions with the zenodo deposit

wdds <- R6::R6Class(classname = "wdds",
                    public = list(
                      parent_id = "15020049",
                      latest_id = "",
                      working_id = "",
                      version_df = data.frame(),
                      initialize = function() {
                        # get parent json
                        parent_url <- sprintf("https://zenodo.org/api/records/%s",parent_id)
                        parent_json <- jsonlite::fromJSON(txt = parent_url)

                        # create versions dataframe
                        versions_json <- jsonlite::fromJSON(parent_json$links$versions)

                        zenodo_id <- as.character(versions_json$hits$hits$id)
                        version_tag <- versions_json$hits$hits$metadata$version

                        self$version_df <- data.frame(zenodo_id = zenodo_id,
                                          version = version_tag,
                                          latest_version = zenodo_id %in% latest_id )

                        # set latest id
                        self$latest_id <- as.character(parent_json$id)


                      }
                      # set working version
                      #
                      # for tracking schema when making docs
                      current_schema_path ="",
                      current_schema_dir = fs::path_dir(the$current_schema_path),
                      current_sub_schema_dir = here::here("inst/extdata/wdds_schema/schemas/"),
                      wdds_version = "latest"
                    )
                    )
