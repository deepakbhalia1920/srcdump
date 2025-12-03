#!/bin/bash

echo "data loading started"

REGION="us-central1"
DB="postgres"
USER_NM="postgres"
#BUCKET="gs://alloydb-gc-usecase/search-usecase/"
BUCKET="gs://alloydb-gc-usecase-newsetup/raw/ecomm/"
echo "${BUCKET}"
ECOMM_FILENAME="fashion_dataset.csv"
echo "${ECOMM_FILENAME}"
ECOMM_TABLE="alloydb_demo.fashion_products_tmp"
echo "${ECOMM_TABLE}"
CLUSTER_NM="alloydb-dev-cluster-new"
echo "ecomm data loading started"


gcloud alloydb clusters import "${CLUSTER_NM}" \
--region="${REGION}" \
--gcs-uri="${BUCKET}""${ECOMM_FILENAME}" \
--database="${DB}" \
--user="${USER_NM}" \
--csv \
--table="${ECOMM_TABLE}"

if [ $? -eq 0 ]; then
    echo "Data loaded successfully in AlloyDB."
else
    echo "Error creating DDL in AlloyDB. Exiting."
    exit 1
fi