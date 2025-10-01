#!/bin/bash

echo "data loading started"

gcloud alloydb clusters import aia-alloydb \
--region=us-central1 \
--gcs-uri=gs://alloydb-usecase/uploads/emp_temp_data.csv \
--database=postgres \
--user=aia-alloydb \
--csv \
--table=emp_info_test