# lm-logs-gcp(beta)
Google Cloud Platform integration to send logs to Logic Monitor

# Integration
Click on **Activate Cloud Shell** and run the following command
**Install**
``` console
source <(curl -s https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/gcp.sh) && 
deploy_lm-logs ${LM_COMPANY_NAME} ${LM_ACCESS_ID} ${LM_ACCESS_KEY}
```
**Delete**
``` console
source <(curl -s https://raw.githubusercontent.com/logicmonitor/lm-logs-gcp/master/script/gcp.sh) && 
delete_lm-logs
```

## Export logs from Stackdriver to Pub Sub
- Go to the Stackdriver page and filter the logs that need to be exported.
- Click Create Sink and name the sink accordingly.
- Choose Cloud Pub/Sub as the destination and select the pub/sub that was created for that purpose. Note: The pub/sub can be located in a different project.
- Click Create and wait for the confirmation message to show up.