#!/bin/bash

echo "data loading started"

REGION="us-central1"
DB="postgres"
USER_NM="aia-alloydb"
TABLE="emp_info_test"
BUCKET="gs://alloydb-usecase/uploads/"
echo "${BUCKET}"
FILENAME="emp_temp_data.csv"
echo "${FILENAME}"
ECOMM_FILENAME="ecommerce_data.csv"
echo "${ECOMM_FILENAME=}"
ECOMM_TABLE="ecommerce_data_tmp"
echo "${ECOMM_TABLE=}"

gsutil cp emp_temp_data.csv gs://alloydb-usecase/uploads/emp_temp_data.csv

gcloud alloydb clusters import aia-alloydb \
--region="${REGION}" \
--gcs-uri="${BUCKET}""${FILENAME}" \
--database="${DB}" \
--user="${USER_NM}" \
--csv \
--table="${TABLE}"

echo "ecomm data loading started"

gcloud alloydb clusters import aia-alloydb \
--region="${REGION}" \
--gcs-uri="${BUCKET}""${ECOMM_FILENAME}" \
--database="${DB}" \
--user="${USER_NM}" \
--csv \
--table="${ECOMM_TABLE}"

echo "data loaded successfully"