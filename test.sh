envVars='{"DYNAMO_ENDPOINT":"http://localhost:8000/","ENV":"development","NEO_URL":"https://jcore-prod.telia.no","TABLE_NAME":"tokens"}'

count=$(echo $envVars | jq '. | length')

for((i=0;i<$count;i++)) 
do
  key=$(echo $envVars | jq -c 'keys | .['$i']')
  value=$(echo $envVars | jq -c '.'$key'')
  echo $key 
  echo $value
done
