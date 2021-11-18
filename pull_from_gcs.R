library(googleCloudStorageR)
options(httr_oauth_cache = FALSE)
token = metagce::gce_token()
# LOOK at 
# https://cran.r-project.org/web/packages/googleCloudStorageR/vignettes/googleCloudStorageR.html
# For more examples

googleCloudStorageR::gcs_auth(token = token)

## get your project name from the API console
proj <- "streamline-resources"

## get bucket info
buckets <- gcs_list_buckets(proj)

bucket = "enron-example"
bucket_info <- gcs_get_bucket(bucket)
bucket_info

objects <- gcs_list_objects(bucket = bucket)

# tfile = tempfile(fileext = ".xls")
tfile = "andrea_ring_000_1_1.pst.0.xls"
if (!file.exists(tfile)) {
  parsed_download <- gcs_get_object(
    objects$name[[1]], 
    bucket = bucket,
    saveToDisk = tfile)
}

