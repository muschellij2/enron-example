
library(readxl)
library(bigrquery)
library(metagce)
library(tidyverse)
library(DBI)



names(enron2)

# rename variables

#data <- enron2 %>%
#  rename_with(~ paste0 ("Var", seq(1:37)))

# could also do




data <- enron2 %>%
  janitor::clean_names() %>%
  mutate(row_index= 1:n())

# get project

project = metagce::gce_project()

# create database name

dataset = "raw_enron"

# set project and database name

bq_dataset = bigrquery::bq_dataset(project = project,
                                   dataset = dataset)

# Create database

if (!bigrquery::bq_dataset_exists(bq_dataset)){
  bigrquery::bq_dataset_create(x = bq_dataset)
}


# Create table name

table = "raw_enron_data"

# Create empty table

bq_tbl = bigrquery::bq_table(project, dataset, table = table)

# Add data to table

#if (!bigrquery::bq_table_exists(bq_tbl) && overwrite) {
#  bigrquery::bq_table_delete(bq_tbl)
#}

if (!bigrquery::bq_table_exists(bq_tbl)) {
  bigrquery::bq_table_create(bq_tbl,
                             fields = bigrquery::as_bq_fields(data))
  
  bigrquery::bq_table_upload(bq_tbl,
                             values = data, fields = bigrquery::as_bq_fields(data))
}



# Read table into R -------------------------------------------------------

con = DBI::dbConnect(
  bigrquery::bigquery(),
  project = project,
  dataset = "raw_enron"
)

df = dplyr::tbl(con, "raw_enron_data")

# Make a df

new <- df %>% 
  collect()

r_and_d_only <- new[-c(1:17),]

new[4:31, 16:20]


