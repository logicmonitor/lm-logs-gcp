package p

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/logicmonitor/lm-logs-sdk-go/ingest"
)

type Resource struct {
	Labels map[string]string `json:"labels"`
	Type   string            `json:"type"`
}

type Event struct {
	Labels      map[string]string      `json:"labels"`
	TextPayload string                 `json:"textPayload"`
	JsonPayload map[string]interface{} `json:"jsonPayload"`
	Timestamp   time.Time              `json:"timestamp"`
	Resource    Resource               `json:"resource"`
}

// PubSubMessage is the payload of a Pub/Sub event. Please refer to the docs for
// additional information regarding Pub/Sub events.
type PubSubMessage struct {
	Data []byte `json:"data"`
}

// HelloPubSub consumes a Pub/Sub message.
func HelloPubSub(ctx context.Context, m PubSubMessage) error {

	logs, err := processEvent(string(m.Data))

	if err != nil {
		fmt.Printf("error while processing event %v\n", err)
	} else {
		lmIngest := ingest.Ingest{
			CompanyName: os.Getenv("LM_COMPANY_NAME"),
			AccessID:    os.Getenv("LM_ACCESS_ID"),
			AccessKey:   os.Getenv("LM_ACCESS_KEY"),
		}

		ingestResponse, err := lmIngest.SendLogs(logs)
		if !ingestResponse.Success || err != nil {
			fmt.Println(string(m.Data))
			fmt.Println(err)
			fmt.Println(ingestResponse)
		}

		json, _ := json.Marshal(logs)
		fmt.Println(string(json))
		fmt.Println(ingestResponse)
	}
	return nil
}
