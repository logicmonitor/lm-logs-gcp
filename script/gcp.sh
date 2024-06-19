#!/bin/bash

TOPIC=export-logs-to-logicmonitor
VM_NAME=lm-logs-forwarder
VPC_NAME=vpc-internal
SUBNET_NAME=subnet-internal
ROUTER_NAME=router-internal
NAT_NAME=nat-internal
FIREWALL_RULE=fw-allow-ssh

function deploy_lm-logs {

	echo "Creating topic"
	gcloud pubsub topics create ${TOPIC}

	echo "Creating subscription"
	gcloud pubsub subscriptions create ${TOPIC} --topic=${TOPIC}

	echo "Creating VPC Network"
	gcloud compute networks create ${VPC_NAME} --subnet-mode=custom

	echo "Creating firewall rule"
	gcloud compute firewall-rules create ${FIREWALL_RULE} \
    --network ${VPC_NAME} \
    --allow tcp:22 \
    --source-ranges 35.235.240.0/20 \
    --target-tags allow-ssh

	echo "Creating subnet"
	gcloud compute networks subnets create ${SUBNET_NAME} \
    --network=${VPC_NAME} \
    --range=10.0.0.0/24

    echo "Getting the region"
    REGION=$(gcloud compute networks subnets list --filter="name=${SUBNET_NAME}" --format="value(region)")

    echo "Creating router"
    gcloud compute routers create ${ROUTER_NAME} \
    --network=${VPC_NAME} \
    --region=${REGION}

    echo "Creating NAT configuration on Router"
    gcloud compute routers nats create ${NAT_NAME} \
    --router=${ROUTER_NAME} \
    --region=${REGION} \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips

	echo "Creating VM"
	gcloud compute instances create ${VM_NAME} \
	 --image debian-11-bullseye-v20240611 \
	 --image-project debian-cloud \
	 --machine-type=e2-micro \
	 --subnet=${SUBNET_NAME} \
	 --network-tier=STANDARD \
	 --tags=allow-ssh \
	 --no-address




	echo "Completed!!!"

}

function delete_lm-logs {

	echo "Deleting VM"
	gcloud compute instances delete ${VM_NAME}

	echo "Deleting NAT configurations"
	gcloud compute routers nats delete ${NAT_NAME} --router=${ROUTER_NAME}

	echo "Deleting routers"
	gcloud compute routers delete ${ROUTER_NAME}

	echo "Deleting subnet"
	gcloud compute networks subnets delete ${SUBNET_NAME}

	echo "Deleting firewall rule"
	gcloud compute firewall-rules delete ${FIREWALL_RULE} --quiet

	echo "Deleting VPC"
	gcloud compute networks delete ${VPC_NAME} --quiet

	echo "Deleting subscription"
	gcloud pubsub subscriptions delete ${TOPIC}

	echo "Deleting topic"
	gcloud pubsub topics delete ${TOPIC}

	echo "Completed!!!"
}