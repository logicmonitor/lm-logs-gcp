#!/bin/bash

TOPIC=export-logs-to-logicmonitor
NAME=lm-logs-forwarder

function deploy_lm-logs {

	echo "Creating topic"
	gcloud pubsub topics create ${TOPIC}

	echo "Creating subscription"
	gcloud pubsub subscriptions create ${TOPIC} --topic=${TOPIC}
	
	echo "Creating VM"
	gcloud compute instances create ${NAME} \
  --image debian-10-buster-v20201014 \
  --image-project debian-cloud \
	--machine-type=e2-micro

	echo "Completed!!!"

}

function delete_lm-logs {

	echo "Deleting VM"
	gcloud compute instances delete ${NAME}

	echo "Deleting subscription"
	gcloud pubsub subscriptions delete ${TOPIC}
	
	echo "Deleting topic"
	gcloud pubsub topics delete ${TOPIC}

	echo "Completed!!!"
}