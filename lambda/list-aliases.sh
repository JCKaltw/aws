#!/bin/bash

# Get list of function names
FUNCTION_NAMES=$(aws lambda list-functions --query 'Functions[*].FunctionName' --output text)

# Initialize empty JSON object
JSON_OBJECT="{}"

# Loop through each function and add its aliases to the JSON object
for FUNCTION_NAME in $FUNCTION_NAMES; do
  ALIASES=$(aws lambda list-aliases --function-name "$FUNCTION_NAME" --output json)
  JSON_OBJECT=$(echo $JSON_OBJECT | jq --arg fn "$FUNCTION_NAME" --argjson aliases "$ALIASES" '. + {($fn): $aliases.Aliases}')
done

echo $JSON_OBJECT
echo -----------------------

jq 'map_values(.[] | select(.Name == "dev") | {Name: (.AliasArn | split(":")[-2]), FunctionVersion: .FunctionVersion})' <<< "$JSON_OBJECT"
