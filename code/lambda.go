package main

import (
	"context"
	"crypto/tls"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/logicmonitor/lm-logs-sdk-go/ingest"

	"github.com/aws/aws-lambda-go/lambda"
)

type GCPEvent struct {
	Message map[string]interface{} `json:"message"`
}

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

func getQueryParameter(key string, request events.APIGatewayProxyRequest) string {
	val, found := request.QueryStringParameters[key]
	if found {
		return val
	}
	panic(fmt.Sprintf("query parameter:%s not found", key))
}

func handler(_ context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	company := getQueryParameter("company", request)
	accessID := getQueryParameter("accessId", request)
	accessKey := getQueryParameter("accessKey", request)

	var event GCPEvent
	err := json.Unmarshal([]byte(request.Body), &event)
	if err != nil {
		panic(err)
	}

	log, err := base64.StdEncoding.DecodeString(event.Message["data"].(string))
	if err != nil {
		panic(err)
	}

	logs , err := processEvent(string(log))

	if err != nil {
		panic(err)
	}

	lmIngest := ingest.Ingest{
		CompanyName: company,
		AccessID:    accessID,
		AccessKey:   accessKey,
	}

	ingestResponse, err := lmIngest.SendLogs(logs)

	if !ingestResponse.Success || err == nil {
		fmt.Println(log)
		fmt.Println(err)
		fmt.Println(ingestResponse)
	}

	return events.APIGatewayProxyResponse{StatusCode: 200, Body: ingestResponse.Message}, nil
}

func main() {
	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: false}
	lambda.Start(handler)
}
