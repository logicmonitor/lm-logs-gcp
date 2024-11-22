#!/bin/bash

branch="${GIT_BRANCH:-master}"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get --allow-releaseinfo-change update -y &&
sudo curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bullseye-fluent-package5.sh | sh
sudo fluent-gem install fluent-plugin-lm-logs &&
sudo fluent-gem install fluent-plugin-lm-logs-gcp &&
sudo fluent-gem install fluent-plugin-gcloud-pubsub-custom &&
curl  https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/${branch}/script/fluentd.conf --output template.conf &&
export LM_COMPANY_DOMAIN=$( [[ -z "${LM_COMPANY_DOMAIN// }" ]] && echo "logicmonitor.com" || echo "$LM_COMPANY_DOMAIN" )
envsubst < template.conf  | sed '/access_id \"\"/d;/access_key \"\"/d;/bearer_token \"\"/d' > fluentd.conf &&
sudo cp fluentd.conf /etc/fluent/fluentd.conf &&
sudo systemctl restart fluentd
