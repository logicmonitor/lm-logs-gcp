#!/bin/bash



function deploy_lm-logs {
	export GCP_PROJECT_ID=$1
	export LM_COMPANY_NAME=$2
	export LM_ACCESS_ID=$3
	export LM_ACCESS_KEY=$4

	sudo apt-get update -y &&
	sudo apt-get install -y rubygems build-essential &&
	sudo apt-get install -y ruby-dev &&
	sudo gem install fluentd --no-doc &&
	sudo gem install fluent-plugin-lm-logs &&
	sudo gem install fluent-plugin-gcloud-pubsub-custom && 
	curl  https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/fluentd.conf --output template.conf &&
	envsubst < template.conf  | cat > fluentd.conf
	fluentd -c ./fluentd.conf
}