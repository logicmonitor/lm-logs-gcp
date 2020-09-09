package main

import (
	"testing"

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

	expectedLogs := []ingest.Log{{
		Message:    "t=2020-09-07T14:36:48+0000 lvl=eror msg=\"Alert Rule Result Error\" logger=alerting.evalContext ruleId=5 name=\"Heap alloc bytes alert\" error=\"tsdb.HandleRequest() error time: unknown unit min in duration 5min\" changing state to=alerting\n",
		ResourceID: map[string]string{"auto.name": "po-grafana-5875cff97f-9pbcc"},
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

	expectedLogs := []ingest.Log{{
		Message:    "\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)",
		ResourceID: map[string]string{"system.gcp.resourcename": "unomaly-collector"},
	}}

	assert.Equal(t, expectedLogs, logs)
}
