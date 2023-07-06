#!/bin/bash

branch="${GIT_BRANCH:-master}"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get --allow-releaseinfo-change update -y &&
sudo curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bullseye-td-agent4.sh | sh
sudo td-agent-gem install fluent-plugin-lm-logs &&
sudo td-agent-gem install fluent-plugin-lm-logs &&
sudo td-agent-gem install fluent-plugin-lm-logs-gcp &&
sudo td-agent-gem install fluent-plugin-gcloud-pubsub-custom &&
curl  https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/${branch}/script/fluentd.conf --output template.conf &&
envsubst < template.conf  | cat > fluentd.conf &&
sudo cp fluentd.conf /etc/td-agent/td-agent.conf &&
sudo systemctl restart td-agent
