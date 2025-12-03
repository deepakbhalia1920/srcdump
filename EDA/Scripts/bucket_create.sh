#!/usr/bin/env bash
# create_gcs_bucket_and_folders_gsutil.sh
# Usage:
#   ./create_gcs_bucket_and_folders_gsutil.sh \
#     --project my-project \
#     --bucket my-bucket-name \
#     --location asia-south1 \
#     --storage-class STANDARD \
#     --folders "raw/data,raw/logs,processed/daily,processed/monthly"

set -euo pipefail

PROJECT_ID="cog01k76j1fr1385r4k0300aq7hxg"
BUCKET_NAME="alloydb-gc-usecase-newsetup"
LOCATION="us-central1"
STORAGE_CLASS="STANDARD"
FOLDERS="raw/forecast,raw/ecomm,raw/eda"
REGION="us-central1"

print_usage() {
  cat <<EOF
Create a GCS bucket and sub-folders using gsutil.
Options:
  --project $PROJECT_ID  
  --bucket $BUCKET_NAME 
  --location $REGION 
  --storage-class $STORAGE_CLASS
  --folders $FOLDERS
  --help
EOF
}

echo "while loop started"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT_ID="$2"; shift 2 ;;
    --bucket) BUCKET_NAME="$2"; shift 2 ;;
    --location) LOCATION="$2"; shift 2 ;;
    --storage-class) STORAGE_CLASS="$2"; shift 2 ;;
    --folders) FOLDERS="$2"; shift 2 ;;
    --help|-h) print_usage; exit 0 ;;
    *) echo "Unknown option: $1"; print_usage; exit 1 ;;
  esac
done

if [[ -z "${PROJECT_ID}" || -z "${BUCKET_NAME}" ]]; then
  echo "ERROR: --project and --bucket are required."
  print_usage
  exit 1
fi

echo "==> Setting project: ${PROJECT_ID}"
gcloud config set project "${PROJECT_ID}" >/dev/null

# Create bucket if not exists
if gsutil ls -b "gs://${BUCKET_NAME}" >/dev/null 2>&1; then
  echo "Bucket gs://${BUCKET_NAME} already exists. Skipping creation."
else
  echo "==> Creating bucket gs://${BUCKET_NAME} in ${LOCATION} (${STORAGE_CLASS})"
  gsutil mb -c "${STORAGE_CLASS}" -l "${LOCATION}" "gs://${BUCKET_NAME}"
fi

echo "subfolder is getting create"
# Create sub-folders
if [[ -n "${FOLDERS}" ]]; then
  IFS=',' read -ra FOLDER_LIST <<< "${FOLDERS}"
  for folder in "${FOLDER_LIST[@]}"; do
    folder="${folder#/}"
    [[ "${folder}" != */ ]] && folder="${folder}/"
    echo "==> Creating folder: gs://${BUCKET_NAME}/${folder}"
    gsutil -q cp -n /dev/null "gs://${BUCKET_NAME}/${folder}"
  done
else
  echo "No folders requested. Bucket created/verified."
fi
