#!/bin/bash
# This script will apply Monitoring as Code configuration to the Dynatrace Tenant
# This includes some naming rules so that all deployed services and sample apps we use later on will be correctly identified

source init_helper.sh 

echo "-----------------------------------------------------------------------"
echo "Configure Dynatrace settings using Monaco - https://github.com/dynatrace-oss/dynatrace-monitoring-as-code"
echo "-----------------------------------------------------------------------"
echo "1. Download Monaco"
curl -L https://github.com/dynatrace-oss/dynatrace-monitoring-as-code/releases/download/v1.1.0/monaco-linux-amd64 --output monaco_cli
chmod +x monaco_cli

echo "2. Execute Monaco"
./monaco_cli -e=monaco-environment.yaml -p=hotday monaco


echo "-----------------------------------------------------------------------"
echo "Create 2 Dynatrace SLOs for simplenode service in staging and production via API as not yet supported through Monaco"
echo "-----------------------------------------------------------------------"
curl -X POST "https://{${DT_TENANT}}/api/v2/slo" \
     -H "accept: */*" \
     -H "Authorization: Api-Token ${DT_API_TOKEN}" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d "{\"enabled\":true,\"name\":\"Success Rate simplenode (PROD)\",\"description\":\"Simplenode Successes Server Rate > 99.98% in PROD\",\"useRateMetric\":true,\"metricRate\":\"builtin:service.successes.server.rate\",\"metricNumerator\":\"\",\"target\":99.98,\"warning\":99.99,\"evaluationType\":\"AGGREGATE\",\"timeframe\":\"-1w\",\"filter\":\"type(\\\"SERVICE\\\"),tag(\\\"keptn_stage:prod\\\"),tag(\\\"keptn_service:simplenode\\\")\"}"

curl -X POST "https://{${DT_TENANT}}/api/v2/slo" \
     -H "accept: */*" \
     -H "Authorization: Api-Token ${DT_API_TOKEN}" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d "{\"enabled\":true,\"name\":\"Success Rate simplenode (STAGING)\",\"description\":\"Simplenode Successes Server Rate > 70.00% in STAGING\",\"useRateMetric\":true,\"metricRate\":\"builtin:service.successes.server.rate\",\"metricNumerator\":\"\",\"target\":70,\"warning\":90,\"evaluationType\":\"AGGREGATE\",\"timeframe\":\"-1w\",\"filter\":\"type(\\\"SERVICE\\\"),tag(\\\"keptn_stage:staging\\\"),tag(\\\"keptn_service:simplenode\\\")\"}"
