#!/bin/bash

# Get list of function names
FUNCTION_NAMES=$(aws lambda list-functions --query 'Functions[*].FunctionName' --output text)

# Initialize empty JSON object
LAYER_JSON_OBJECT="{}"

for FUNCTION_NAME in $FUNCTION_NAMES; do
  LAYERS=$(aws lambda get-function --function-name ${FUNCTION_NAME} --query 'Configuration.Layers[*].Arn')
  LAYER_JSON_OBJECT=$(echo $LAYER_JSON_OBJECT | jq --arg fn "$FUNCTION_NAME" --argjson layers "$LAYERS" '. + {($fn): $layers}')
done

echo $LAYER_JSON_OBJECT | jq .
