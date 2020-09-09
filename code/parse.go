package main

import (
	"encoding/json"
	"fmt"

	"github.com/logicmonitor/lm-logs-sdk-go/ingest"
)

func processEvent(str string) ([]ingest.Log, error) {

	var logEvent Event
	err := json.Unmarshal([]byte(str), &logEvent)
	if err != nil {
		panic(err)
	}

	resourceKey, resourceVal := extractResource(logEvent)
	text := extractText(logEvent)

	if resourceKey == "" || resourceVal == "" {
		return nil, fmt.Errorf("could not extract resource mapping or text key:%s val:%s text:%s", resourceKey, resourceVal, text)
	}

	logs := []ingest.Log{{
		Message:    text,
		ResourceID: map[string]string{resourceKey: resourceVal},
	}}

	return logs, nil
}

func extractResource(event Event) (string, string) {
	val, ok := event.Labels["container.googleapis.com/pod_name"]
	if ok {
		return "auto.name", val
	}

	val, ok = event.Labels["compute.googleapis.com/resource_name"]
	if ok {
		return "system.gcp.resourcename", val
	}
	return "", ""
}

func extractText(event Event) string {

	if event.JsonPayload != nil {
		b, err := json.Marshal(event.JsonPayload)
		if err != nil {
			return string(b)
		}
	}

	if event.TextPayload != "" {
		return event.TextPayload
	}

	return ""
}
