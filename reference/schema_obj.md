# Schema Object

A class for getting schema properties.

## Value

List of of data frames. Create a list from a schema object

Creates a data.frame with the fields name and type

data frame with type and name Get schema references

Parses \$ref calls in a schema. Can retrieve internal
('"\$ref":"#/definitions/someDef") or external references
('"\$ref":"schemas/datacite/datacite.json"').

For external references, it can handle both pointers and references to
entire schemas. This function navigates between parent and child schemas
by manipulating variables in the package environment `the`.

data frame with name or type. Process Array Items

Processes array items so they can be added to a data frame.

data frames with name and type for array items that are objects or
character strings atomic (string, null, Boolean, etc) array items.

## See also

Other Schema:
[`datacite_schema`](https://viralemergence.github.io/wddsWizard/reference/datacite_schema.md),
[`disease_data_schema`](https://viralemergence.github.io/wddsWizard/reference/disease_data_schema.md),
[`project_metadata_schema`](https://viralemergence.github.io/wddsWizard/reference/project_metadata_schema.md),
[`schema_properties`](https://viralemergence.github.io/wddsWizard/reference/schema_properties.md),
[`schema_terms`](https://viralemergence.github.io/wddsWizard/reference/schema_terms.md),
[`wdds_schema`](https://viralemergence.github.io/wddsWizard/reference/wdds_schema.md)

## Public fields

- `schema_path`:

  (`character(1)`)  
  path to the schema file.

- `schema_list_out`:

  ([`list()`](https://rdrr.io/r/base/list.html))  
  List of data frames with schema properties.

- `wdds_version`:

  (`character(1)`)  
  version of wdds used

- `current_schema_path`:

  (`character(1)`)  
  current schema file path

- `current_schema_dir`:

  (`character(1)`)  
  current schema directory path

- `current_sub_schema_dir`:

  (`character(1)`)  
  current sub schema directory path

- `parent_schema_path`:

  (`character(1)`)  
  parent schema file path

- `parent_schema_dir`:

  (`character(1)`)  
  parent schema directory

- `array_items`:

  ([`c()`](https://rdrr.io/r/base/c.html))  
  array items

- `array_items_skip`:

  (`logical(1)`)  
  array items to skip

- `array_items_parent`:

  (`logical(1)`)  
  parent array items

## Methods

### Public methods

- [`schema_obj$new()`](#method-schema_obj-new)

- [`schema_obj$create_schema_list()`](#method-schema_obj-create_schema_list)

- [`schema_obj$create_object_list()`](#method-schema_obj-create_object_list)

- [`schema_obj$get_ref_list()`](#method-schema_obj-get_ref_list)

- [`schema_obj$process_array_items()`](#method-schema_obj-process_array_items)

- [`schema_obj$clone()`](#method-schema_obj-clone)

------------------------------------------------------------------------

### Method `new()`

Creates a new instance of this
[R6](https://r6.r-lib.org/reference/R6Class.html) class.

#### Usage

    schema_obj$new(schema_path, wdds_version = "latest")

#### Arguments

- `schema_path`:

  Character. File path for the schema (`character(1)`)  

- `wdds_version`:

  Character. Version of wdds used (`character(1)`)  

------------------------------------------------------------------------

### Method `create_schema_list()`

Create an expanded schema object

Produces a list of data frame with name and type for the schema. This is
a recursive set of function and may be expanded to get other properties.

#### Usage

    schema_obj$create_schema_list(schema_path = self$current_schema_path)

#### Arguments

- `schema_path`:

  Character. Path to a json-schema. Default is the current schema path
  from the package environment,

------------------------------------------------------------------------

### Method `create_object_list()`

#### Usage

    schema_obj$create_object_list(x, idx, schema_dir)

#### Arguments

- `x`:

  List. Schema property or definition

- `idx`:

  Name from schema property

- `schema_dir`:

  Character. directory where the schema is stored

------------------------------------------------------------------------

### Method `get_ref_list()`

#### Usage

    schema_obj$get_ref_list(x, schema_dir)

#### Arguments

- `x`:

  List. Must have property "\$ref"

- `schema_dir`:

  Character. Directory for the current schema.

------------------------------------------------------------------------

### Method `process_array_items()`

#### Usage

    schema_obj$process_array_items(array_items, out)

#### Arguments

- `array_items`:

  list. List of array items for processing.

- `out`:

  data frame. Data frame with name and type.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    schema_obj$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
