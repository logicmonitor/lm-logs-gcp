#!/bin/bash

LM_COMPANY_NAME=company
LM_ACCESS_ID=id
LM_ACCESS_KEY=key
TOPIC=export-logs-to-logicmonitor
NAME=lm-logs-forwarder
SOURCE_ZIP=function-source.zip


function deploy_lm-logs {

	LM_COMPANY_NAME=$0
	LM_ACCESS_ID=$1
	LM_ACCESS_KEY=$2

	echo "Creating topic"
	gcloud pubsub topics create ${TOPIC}

	echo "Creating storage"
	gsutil mb gs://${NAME}

	echo "Downloading source code"
	curl https://lm-logs-forwarder.s3-us-west-1.amazonaws.com/gcp/${SOURCE_ZIP} --output ${SOURCE_ZIP}

	echo "Uploading source code to bucket"
	gsutil cp ${SOURCE_ZIP} gs://${NAME}/

	echo "Deploying google function"
	gcloud functions deploy ${NAME} \
	--runtime go113 \
	--trigger-topic=${TOPIC} \
	--entry-point=HelloPubSub \
	--allow-unauthenticated \
	--set-env-vars=LM_COMPANY_NAME=${LM_COMPANY_NAME},LM_ACCESS_ID=${LM_ACCESS_ID},LM_ACCESS_KEY=${LM_ACCESS_KEY} \
	--stage-bucket=${NAME} \
	--memory=128MB \
	--source=gs://lm-logs-forwarder/${SOURCE_ZIP}

	echo "Completed!!!"
}


function delete_lm-logs {
	echo "Deleting function"
	gcloud functions delete ${NAME}

	echo "Deleting storage"
	gsutil rm -r gs://${NAME}
	rm ${SOURCE_ZIP}

	echo "Deleting topic"
	gcloud pubsub topics delete ${TOPIC}

	echo "Completed!!!"
}