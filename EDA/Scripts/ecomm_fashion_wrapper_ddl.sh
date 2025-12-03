#!/bin/bash

# --- Configuration ---
PROJECT_ID="cog01k76j1fr1385r4k0300aq7hxg"
REGION="us-central1"
CLUSTER_ID="aia-alloydb"
INSTANCE_ID="aia-alloydb-primary"
HOST="10.0.0.11"
PORT="5432"
DATABASE_NAME="postgres"
SQL_FILE="newset_ecomm_fashion_ddl.sql"
BUCKET="gs://alloydb-gc-usecase/uploads"
USER="postgres"
PASSWORD="AlloyDB_Dev"
ACCOUNT="deepak.kumar214e17@cognizant.com"
PROJECT_NAME="cog01k76j1fr1385r4k0300aq7hxg"


echo "${SQL_FILE}"
# Export password for psql
export PGPASSWORD=$PASSWORD

ALLOYDB_CLUSTER_ID="alloydb-dev-cluster-new"
ALLOYDB_PRIMARY_INSTANCE_ID="alloydb-dev-primary-new"
ALLOYDB_REGION="us-central1"

gcloud config set account ${ACCOUNT}
gcloud config set project ${PROJECT_NAME}

#ALLOYDB_IP=$(gcloud alloydb instances describe ${ALLOYDB_PRIMARY_INSTANCE_ID} \
#    --cluster=${ALLOYDB_CLUSTER_ID} \
#    --region=${ALLOYDB_REGION} \
#    --format="value(ipAddress)") # Or value(networkConfig.privateIpAddress) if that's what worked

#echo "${ALLOYDB_IP}"
#if [ -z "$ALLOYDB_IP" ]; then
#    echo "Error: Could not retrieve AlloyDB IP address. Exiting."
#    exit 1
#fi

#echo "AlloyDB Primary Instance IP: ${ALLOYDB_IP}"

# SQL to create table
sudo apt install postgresql-client -y
psql --version

psql -h "${HOST}" -p $PORT -U $USER -d $DATABASE_NAME -f ${SQL_FILE}