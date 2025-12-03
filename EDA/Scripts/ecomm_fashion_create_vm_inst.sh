#!/bin/bash

# Updated script to create VM, ensure AlloyDB connectivity, and run DDL

INSTANCE_NAME="agent-my-vm-test16"
ZONE_NAME="us-central1-a"
MACHINE_NAME="e2-medium"
IMAGE_FAMILY="debian-11"
IMAGE_PROJECT="debian-cloud"
TAG="ssh-access"
SCOPES="https://www.googleapis.com/auth/cloud-platform"
ACCOUNT="deepak.kumar214e17@cognizant.com"
PROJECT_NAME="cog01k76j1fr1385r4k0300aq7hxg"

# VPC and Subnet details (update these as per your environment)
VPC_NAME="default"
SUBNET_NAME="default"

# AlloyDB details
ALLOYDB_HOST="10.123.50.2"
ALLOYDB_PORT=5432

echo "Creating or verifying VM instance: $INSTANCE_NAME"

gcloud config set account ${ACCOUNT}
gcloud config set project ${PROJECT_NAME}

# Check if VM exists and is running
VM_STATUS=$(gcloud compute instances describe "$INSTANCE_NAME" --zone="$ZONE_NAME" --format='get(status)' 2>/dev/null)
echo "Current VM status: $VM_STATUS"

if [[ "$VM_STATUS" == "RUNNING" ]]; then
    echo "VM $INSTANCE_NAME is already running. Continuing..."
else
    echo "VM $INSTANCE_NAME is not running. Creating VM..."
    gcloud compute instances create "${INSTANCE_NAME}" \
        --zone="${ZONE_NAME}" \
        --machine-type="${MACHINE_NAME}" \
        --image-family="${IMAGE_FAMILY}" \
        --image-project="${IMAGE_PROJECT}" \
        --tags="${TAG}" \
        --scopes="${SCOPES}" \
        --network="${VPC_NAME}" \
        --subnet="${SUBNET_NAME}" \
        --no-address
fi

if [ $? -ne 0 ]; then
    echo "Error while creating VM. Exiting."
    exit 1
fi

echo "Ensuring firewall rule for AlloyDB connectivity..."
gcloud compute firewall-rules describe allow-alloydb --format='get(name)' 2>/dev/null
if [ $? -ne 0 ]; then
    gcloud compute firewall-rules create allow-alloydb \
        --allow=tcp:${ALLOYDB_PORT} \
        --network=${VPC_NAME} \
        --source-tags=${TAG}
fi

echo "Waiting for VM and AlloyDB to be ready..."
gcloud compute ssh "${INSTANCE_NAME}" --zone="${ZONE_NAME}" --command="sudo apt-get update && sudo apt-get install -y netcat"

sleep 60

# Check connectivity from VM to AlloyDB
echo "Checking connectivity to AlloyDB from VM..."
#gcloud compute ssh "${INSTANCE_NAME}" --zone="${ZONE_NAME}" --command="nc -zv ${ALLOYDB_HOST} ${ALLOYDB_PORT}"
#if [ $? -ne 0 ]; then
#    echo "Cannot reach AlloyDB from VM. Please check VPC and firewall settings."
#    exit 1
#fi

# Copy files to VM
SCRIPT_FILES=("newset_ecomm_fashion_wrapper_ddl.sh" "newset_ecomm_fashion_ddl.sql")
USERNAME="deepak_kumar214e17"
TGT_PATH="/home/${USERNAME}/"
SRC_PATH="/home/deepak_kumar214e17/alloydb_gc/ecomm/script/"

for FILE in "${SCRIPT_FILES[@]}"; do
    echo "Copying $SRC_PATH$FILE"
    gcloud compute scp "${SRC_PATH}${FILE}" "${USERNAME}@${INSTANCE_NAME}:${TGT_PATH}" --zone="${ZONE_NAME}"
done

echo "Files copied successfully."

# Execute wrapper script on VM
echo "Executing DDL wrapper script on VM..."
gcloud compute ssh "${INSTANCE_NAME}" --zone="${ZONE_NAME}" --command="bash ${TGT_PATH}newset_ecomm_fashion_wrapper_ddl.sh"

if [ $? -eq 0 ]; then
    echo "DDL created successfully in AlloyDB."
else
    echo "Error creating DDL in AlloyDB. Exiting."
    exit 1
fi