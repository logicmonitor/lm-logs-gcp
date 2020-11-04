#!/bin/bash

TOPIC=export-logs-to-logicmonitor
NAME=lm-logs-forwarder

function deploy_lm-logs {

	echo "Creating topic"
	gcloud pubsub topics create ${TOPIC}

	gcloud pubsub subscriptions create --topic=${TOPIC}
	
	echo "Creating VM"
	gcloud compute instances create ${NAME} \
  --image debian-10-buster-v20201014 \
  --image-project debian-cloud \
	--machine-type=e2-standard-2

	echo "Completed!!!"

}


function delete_lm-logs {

	echo "Deleting topic"
	gcloud pubsub topics delete ${TOPIC}

	echo "Deleting VM"
	gcloud compute instances delete ${NAME}

	echo "Completed!!!"
}