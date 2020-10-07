package p

import (
	"testing"
	"time"

	"github.com/logicmonitor/lm-logs-sdk-go/ingest"
	"github.com/stretchr/testify/assert"
)

func TestProcessEventContainer(t *testing.T) {

	text :=
		`{
	   "insertId":"1gq003wg20ln6hz",
	   "labels":{
		  "compute.googleapis.com/resource_name":"gke-gke-customer-production-962d0e3b-86k9",
		  "container.googleapis.com/namespace_name":"customer-production",
		  "container.googleapis.com/pod_name":"po-grafana-5875cff97f-9pbcc",
		  "container.googleapis.com/stream":"stdout"
	   },
	   "logName":"projects/kubernetes-1aee/logs/grafana",
	   "receiveTimestamp":"2020-09-07T14:36:53.106167446Z",
	   "resource":{
		  "labels":{
			 "cluster_name":"gke",
			 "container_name":"grafana",
			 "instance_id":"5925929679396873733",
			 "namespace_id":"customer-production",
			 "pod_id":"po-grafana-5875cff97f-9pbcc",
			 "project_id":"kubernetes-1aee",
			 "zone":"europe-west4-a"
		  },
		  "type":"container"
	   },
	   "severity":"INFO",
	   "textPayload":"t=2020-09-07T14:36:48+0000 lvl=eror msg=\"Alert Rule Result Error\" logger=alerting.evalContext ruleId=5 name=\"Heap alloc bytes alert\" error=\"tsdb.HandleRequest() error time: unknown unit min in duration 5min\" changing state to=alerting\n",
	   "timestamp":"2020-09-07T14:36:48.03093257Z"
	}`

	logs, _ := processEvent(text)

	time, _ := time.Parse(time.RFC3339, "2020-09-07T14:36:48.03093257Z")
	expectedLogs := []ingest.Log{{
		Message:    "t=2020-09-07T14:36:48+0000 lvl=eror msg=\"Alert Rule Result Error\" logger=alerting.evalContext ruleId=5 name=\"Heap alloc bytes alert\" error=\"tsdb.HandleRequest() error time: unknown unit min in duration 5min\" changing state to=alerting\n",
		ResourceID: map[string]string{"auto.name": "po-grafana-5875cff97f-9pbcc"},
		Timestamp:  time,
	}}

	assert.Equal(t, expectedLogs, logs)
}

func TestProcessEventVM(t *testing.T) {

	text :=
		`{
"insertId":"thcqinwfl5cm7ffls",
"labels":{
   "compute.googleapis.com/resource_name":"unomaly-collector"
},
"logName":"projects/kubernetes-1aee/logs/lm_collector",
"receiveTimestamp":"2020-09-08T14:11:30.390372113Z",
"resource":{
   "labels":{
      "instance_id":"2038806619492823300",
      "project_id":"kubernetes-1aee",
      "zone":"europe-west4-b"
   },
   "type":"gce_instance"
},
"textPayload":"\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)",
"timestamp":"2020-09-08T14:11:26.912465391Z"
}`

	logs, _ := processEvent(text)

	time, _ := time.Parse(time.RFC3339, "2020-09-08T14:11:26.912465391Z")
	expectedLogs := []ingest.Log{{
		Message:    "\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)",
		ResourceID: map[string]string{"system.gcp.resourcename": "unomaly-collector"},
		Timestamp:  time,
	}}

	assert.Equal(t, expectedLogs, logs)
}

func TestProcessEventVM2(t *testing.T) {

	text :=
		`{
  "insertId": "7vo7e1vjzmchai2al",
  "jsonPayload": {
      "host": "deploy-2",
      "ident": "snmpd",
      "message": "Connection from UDP: [10.164.0.250]:49103->[10.164.0.242]:161",
      "pid": "3537"
  },
  "labels": {
      "compute.googleapis.com/resource_name": "deploy-2"
  },
  "logName": "projects/kubernetes-1aee/logs/syslog",
  "receiveTimestamp": "2020-09-09T12:45:36.594149653Z",
  "resource": {
      "labels": {
          "instance_id": "1803528268121191437",
          "project_id": "kubernetes-1aee",
          "zone": "europe-west4-b"
      },
      "type": "gce_instance"
  },
  "timestamp": "2020-09-09T12:45:34Z"
}`

	logs, _ := processEvent(text)

	time, _ := time.Parse(time.RFC3339, "2020-09-09T12:45:34Z")
	expectedLogs := []ingest.Log{{
		Message:    "{\"host\":\"deploy-2\",\"ident\":\"snmpd\",\"message\":\"Connection from UDP: [10.164.0.250]:49103-\\u003e[10.164.0.242]:161\",\"pid\":\"3537\"}",
		ResourceID: map[string]string{"system.gcp.resourcename": "deploy-2"},
		Timestamp:  time,
	}}

	assert.Equal(t, expectedLogs, logs)
}

func TestProcessEventFunction(t *testing.T) {

	text :=
		`{
  "insertId": "000000-78e76f54-26bb-44a9-99ac-515a917b85be",
  "labels": {
      "execution_id": "eag2qpwczdjy"
  },
  "logName": "projects/kubernetes-1aee/logs/cloudfunctions.googleapis.com%2Fcloud-functions",
  "receiveTimestamp": "2020-09-09T11:36:57.608609313Z",
  "resource": {
      "labels": {
          "function_name": "log-frontend-metrics-eu",
          "project_id": "kubernetes-1aee",
          "region": "europe-west1"
      },
      "type": "cloud_function"
  },
  "severity": "INFO",
  "textPayload": "event message: \"situations load more\", properties: {\"auto\":true,\"referrerPath\":\"/situations\"}",
  "timestamp": "2020-09-09T11:36:47.241Z",
  "trace": "projects/kubernetes-1aee/traces/7d13fb2fcce12d25aec983d471ef8be1"
}`

	logs, _ := processEvent(text)

	time, _ := time.Parse(time.RFC3339, "2020-09-09T11:36:47.241Z")
	expectedLogs := []ingest.Log{{
		Message:    "event message: \"situations load more\", properties: {\"auto\":true,\"referrerPath\":\"/situations\"}",
		ResourceID: map[string]string{"system.gcp.resourcename": "projects/kubernetes-1aee/locations/europe-west1/functions/log-frontend-metrics-eu"},
		Timestamp:  time,
	}}

	assert.Equal(t, expectedLogs, logs)
}
