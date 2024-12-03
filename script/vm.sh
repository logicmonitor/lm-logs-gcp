#!/bin/bash

branch="${GIT_BRANCH:-master}"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get --allow-releaseinfo-change update -y &&
sudo curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bullseye-fluent-package5.sh | sh
sudo fluent-gem install fluent-plugin-lm-logs &&
sudo fluent-gem install fluent-plugin-lm-logs-gcp &&
sudo fluent-gem install fluent-plugin-gcloud-pubsub-custom &&
curl  https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/${branch}/script/fluentd.conf --output template.conf &&
if [[ -z "${LM_COMPANY_DOMAIN// }" ]]; then
  echo "LM_COMPANY_DOMAIN is not set. Setting default value to: logicmonitor.com"
  export LM_COMPANY_DOMAIN="logicmonitor.com"
elif [[ "$LM_COMPANY_DOMAIN" != "logicmonitor.com" && "$LM_COMPANY_DOMAIN" != "lmgov.us" && "$LM_COMPANY_DOMAIN" != "qa-lmgov.us" ]]; then
  echo "Error: Invalid LM_COMPANY_DOMAIN value. Allowed values are: logicmonitor.com, lmgov.us, qa-lmgov.us"
  exit 1
else
  export LM_COMPANY_DOMAIN="$LM_COMPANY_DOMAIN"
fi
envsubst < template.conf  | sed '/access_id \"\"/d;/access_key \"\"/d;/bearer_token \"\"/d' > fluentd.conf &&
sudo cp fluentd.conf /etc/fluent/fluentd.conf &&
sudo systemctl restart fluentd
