# lm-logs-gcp(beta)
Google Cloud Platform integration to send logs to LogicMonitor

Click on **Activate Cloud Shell** and run the following command
Use the following command to select project.
``` console
gcloud config set project [PROJECT_ID]
```

Install Integration
``` console
source <(curl -s https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/gcp.sh) && deploy_lm-logs
```

 Following resources will be created
- PubSub topic named **export-to-logicmonitor** and a pull subscription.
- VM named **lm-logs-forwarder**.

If you want to delete it later
``` console
source <(curl -s https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/gcp.sh) && deploy_lm-logs
```

After the script in completed, go to Virtual Machine named **lm-logs-forwarder** , SSH into it and run the following command.

``` console
export GCP_PROJECT_ID="${GCP_PROJECT_ID}"
export LM_COMPANY_NAME="${LM_COMPANY_NAME}"
export LM_ACCESS_ID="${LM_ACCESS_ID}"
export LM_ACCESS_KEY="${LM_ACCESS_KEY}"

source <(curl -s https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/vm.sh)
```

## Export logs from Stackdriver to Pub Sub
- Go to the Stackdriver page and filter the logs that need to be exported.
- Click Create Sink and name the sink accordingly.
- Choose Cloud Pub/Sub as the destination and select **export-to-logicmonitor**. Note: The pub/sub can be located in a different project.
- Click Create and wait for the confirmation message to show up.

# Note
We support **VM Instance** and **Google function** logs only.