#!/bin/bash

branch="${GIT_BRANCH:-master}"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get --allow-releaseinfo-change update -y &&
sudo apt-get install -y rubygems build-essential &&
sudo apt-get install -y ruby-dev &&
sudo gem install fluentd --no-doc &&
sudo gem install fluent-plugin-lm-logs &&
sudo gem install fluent-plugin-gcloud-pubsub-custom &&
sudo gem install fluent-plugin-lm-logs-gcp &&
curl  https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/${branch}/script/fluentd.conf --output template.conf &&
envsubst < template.conf  | cat > fluentd.conf
sudo fluentd -c ./fluentd.conf
