# lm-logs-gcp(beta)
Google Cloud Platform integration to send logs to Logic Monitor

# Steps
#### Create cloud Pub Sub
- Go to the Cloud Pub Sub console and create a new topic.
- Give that topic an explicit name such as **export-logs-to-logic-monitor** and Save. 

#### Create cloud storage
- Go to cloud storage
- Click create bucket, name the bucket **lm-logs-forwarder** , and click create.

#### Create google function
- Go to Google cloud function and create new function
- Name the function **lm-logs-forwarder**
- Select trigger as Cloud Pub/Sub
- Select the topic you created before **export-logs-to-logic-monitor**. 
- Click on **Variables, networking and advanced settings** and select **environment variables** tab and add **LM_COMPANY_NAME** , **LM_ACCESS_ID** , **LM_ACCESS_KEY** and click next.
- Download ZIP from https://lm-logs-forwarder.s3-us-west-1.amazonaws.com/gcp/function-source.zip
- Select the **Runtime as Go 1.13** and source code as ZIP Upload.
- Name the stage bucket **lm-logs-forwarder**.
- Then click Deploy.

#### Export logs from Stackdriver to Pub Sub
- Go to the Stackdriver page and filter the logs that need to be exported.
- Click Create Sink and name the sink accordingly.
- Choose Cloud Pub/Sub as the destination and select the pub/sub that was created for that purpose. Note: The pub/sub can be located in a different project.
- Click Create and wait for the confirmation message to show up.
