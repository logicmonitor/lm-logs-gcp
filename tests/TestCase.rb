require 'test/unit'
require './helper'
class TestCase < Test::Unit::TestCase
  include Helper
  def setup
    @outpath = "/tmp/fluentd-test-output.log"
    @outfile = File::open(@outpath, File::RDWR|File::TRUNC|File::CREAT)
    File.chmod(0666, @outpath)
    end

  def teardown
    @outfile.close
  end

  # test case for records having resource_name mapping
  def test_records_with_resourcename
    emitted = {
      "textPayload"=> "test log",
      "resource"=> {
        "type"=> "cloud_function",
        "labels"=> {
          "function_name"=> "testfunctionlogsToPubsub",
          "region"=> "asia-south1",
          "project_id"=> "logicmonitor.com:api-project-650342240768"
        }
      }
    }
    expected_with_resourcename = {
      "log" => "test log",
      "_lm.resourceId" => {
        "system.gcp.resourcename" => "projects/logicmonitor.com:api-project-650342240768/locations/asia-south1/functions/testfunctionlogsToPubsub"
        },
      "date" => "2021-04-18:09:35:39"
    }
    run_resourcemapping_case(emitted, expected_with_resourcename)
  end

  # test case for records containing instanceId or resourceid mapping
  def test_records_with_resourceid
    emitted =  {
      "jsonPayload" => {"some_key"=>"some json"},
      "resource"=> {
        "type"=> "gce_instance",
        "labels"=> {
            "project_id"=> "development-198123",
            "zone"=> "us-central1-a",
            "instance_id"=> "1437928523886234104"
        }
      }
    }
    expected_with_resourceid={
      "log" => "some log",
      "_lm.resourceId" => {
        "system.gcp.resourceid" => "5229353360185505344"
      }
    }
    run_resourcemapping_case(emitted, expected_with_resourceid)
  end

  # test case for records having textPayload as the message
  def test_records_with_textPayload
    emitted = {
     "textPayload"=> "test log",
     "resource"=> {
        "type"=> "cloud_function",
        "labels"=> {
            "function_name"=> "testfunctionlogsToPubsub",
            "region"=> "asia-south1",
            "project_id"=> "logicmonitor.com:api-project-650342240768"
        }
     }
  }
  expected_with_textPayload={
    "message"=>"test log",
      "_lm.resourceId" => {
        "system.gcp.resourcename" => "projects/logicmonitor.com:api-project-650342240768/locations/asia-south1/functions/testfunctionlogsToPubsub"
        },
      "date" => "2021-04-18:09:35:39"
  }
  run_message_case(emitted,expected_with_textPayload)
  end

  # test case for records having jsonPayload as the message
  def test_records_with_jsonPayload
      emitted = {
       "jsonPayload" => { "some_key"=>"some json" },
       "resource"=> {
          "type"=> "cloud_function",
          "labels"=> {
              "function_name"=> "testfunctionlogsToPubsub",
              "region"=> "asia-south1",
              "project_id"=> "logicmonitor.com:api-project-650342240768"
          }
       }
    }
    expected_with_jsonPayload={
      "message"=> "{\"some_key\":\"some json\"}",
        "_lm.resourceId" => {
          "system.gcp.resourcename" => "projects/logicmonitor.com:api-project-650342240768/locations/asia-south1/functions/testfunctionlogsToPubsub"
          },
        "date" => "2021-04-18:09:35:39"
    }
    run_message_case(emitted,expected_with_jsonPayload)
    end
end