#!/bin/bash

# --- Configuration ---
PROJECT_ID="dotengage"
REGION="us-central1"
CLUSTER_ID="aia-alloydb"
INSTANCE_ID="aia-alloydb-primary"
HOST="10.0.0.8"
PORT="5432"
DATABASE_NAME="postgres"
SQL_FILE="newset_ecomm_fashion_presql.sql"
BUCKET="gs://alloydb-usecase/uploads"
USER="postgres"
PASSWORD="AlloyDB_Dev"

# Export password for psql
export PGPASSWORD=$PASSWORD

# SQL to create table
sudo apt install postgresql-client -y
psql --version

psql -h $HOST -p $PORT -U $USER -d $DATABASE_NAME -f $SQL_FILE