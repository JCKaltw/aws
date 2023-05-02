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
echo --------------ALIAS CONFIGURATION ---------

jq 'map_values(.[] | select(.Name == "dev") | {Name: (.AliasArn | split(":")[-2]), FunctionVersion: .FunctionVersion})' <<< "$JSON_OBJECT"

echo ---------------LAYER VERSIONS --------

# Initialize empty JSON object
LAYER_JSON_OBJECT="{}"

for FUNCTION_NAME in $FUNCTION_NAMES; do
  LAYERS=$(aws lambda get-function --function-name ${FUNCTION_NAME} --query 'Configuration.Layers[*].Arn')
  LAYER_JSON_OBJECT=$(echo $LAYER_JSON_OBJECT | jq --arg fn "$FUNCTION_NAME" --argjson layers "$LAYERS" '. + {($fn): $layers}')
done

echo $LAYER_JSON_OBJECT | jq .
