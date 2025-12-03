#!/bin/bash

# Variables
REPO_URL="https://github.com/deepakbhalia1920/srcdump.git"
CLONE_DIR="raw_dataset"
CLONE_DIR_ECOMM="/home/deepak_kumar214e17/raw_dataset/Ecommerce/dataset"
BUCKET_NAME="gs://alloydb-gc-usecase-newsetup/raw/ecomm/"
#BUCKET_NAME="gs://alloydb-gc-usecase/search-usecase/"
#FOLDER_TO_UPLOAD="load_data*.sh"  # relative path inside repo
HOMEDIR="/home/deepak_kumar214e17"

# Clone the repo
echo "copying the file from gitrepo to gcs bucket"
#git clone "$REPO_URL" "$CLONE_DIR"

# Expand wildcard into array

# Set permissions
cd "$HOMEDIR/$CLONE_DIR"
git pull
sleep 5
echo ""${CLONE_DIR_ECOMM}
cd "${CLONE_DIR_ECOMM}"
#FILES_TO_UPLOAD=(*ecommerce*)
#echo "${FILES_TO_UPLOAD[@]}"

FILES_TO_UPLOAD="fashion_dataset.csv"
echo "${FILES_TO_UPLOAD}"

#chmod 777 "$HOMEDIR/$CLONE_DIR/${FILES_TO_UPLOAD[@]}"
#chmod 777 "${FILES_TO_UPLOAD[@]}"

chmod 777 "${FILES_TO_UPLOAD}"
wc -l "${FILES_TO_UPLOAD}"
sed '1d' "$FILES_TO_UPLOAD" > tmp_fashion.csv
wc -l tmp_fashion.csv
mv tmp_fashion.csv "$FILES_TO_UPLOAD"
chmod 777 "${FILES_TO_UPLOAD}"
wc -l "${FILES_TO_UPLOAD}"


#sed '1d' "${FILE_NAME}" > "${FILE_NAME}"
#chmod 777 "${FILE_NAME}"

# Upload to GCS
#gsutil -m cp "$HOMEDIR/$CLONE_DIR/${FILES_TO_UPLOAD[@]}" "$BUCKET_NAME"
#gsutil -m cp "${FILES_TO_UPLOAD[@]}" "$BUCKET_NAME"

gsutil -m cp "${FILES_TO_UPLOAD}" "$BUCKET_NAME"

# Upload to GCS
#gsutil -m cp -r "$HOMEDIR/$CLONE_DIR/$FOLDER_TO_UPLOAD" "$BUCKET_NAME"

if [ $? -eq 0 ]; then
    echo "File moved to GCS bucket successfully."
else
    echo "Error file not moved to GCS location. hence exiting."
    exit 1
fi