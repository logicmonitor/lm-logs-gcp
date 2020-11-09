# lm-logs-gcp(beta)
Google Cloud Platform integration to send logs to LogicMonitor

## Prerequisites

- LogicMonitor API access tokens.
- We support **VM Instance** logs only.

## Installation instructions

Click **Activate Cloud Shell** on the top right. This opens the Cloud Shell Terminal below the workspace. 

In the Terminal, run the following commands to select the project.
``` console
gcloud config set project [PROJECT_ID]
```

Run the following to install the integration:
``` console
source <(curl -s https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/gcp.sh) && deploy_lm-logs
```

Installing the integration creates these resources:
- PubSub topic named **export-logs-to-lm** and a pull subscription.
- Virtual Machine (VM) named **lm-logs-forwarder**.

Note: You will be prompted to confirm the region where the VM is deployed. This should be configured by default within your project.

After the script is completed, go to the VM named **lm-logs-forwarder**: 
 
Compute Engine > VM Instances > (select LM-Logs-forward) > Remote access > (Select SSH)

SSH into it and run the following command.

``` console
export GCP_PROJECT_ID="${GCP_PROJECT_ID}"
export LM_COMPANY_NAME="${LM_COMPANY_NAME}"
export LM_ACCESS_ID="${LM_ACCESS_ID}"
export LM_ACCESS_KEY="${LM_ACCESS_KEY}"

source <(curl -s https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/vm.sh)
```

## Export logs from Logging to Pub Sub
- Go to the Logging page and filter the logs that need to be exported.
- Click **Actions > Create** sink and under **Sink details**, provide the name.
- Under **Sink destination**, choose **Cloud Pub/Sub** as the destination and select **export-logs-to-lm**. Note: The pub/sub can be located in a different project.
- Click **Create sink**.

If there are no issues you should see the logs stream into the Logs page in LogicMonitor.

## Removing the integration

Run the following commands to delete the integration and all its resources: 
``` console
source <(curl -s https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/gcp.sh) && delete_lm-logs
```