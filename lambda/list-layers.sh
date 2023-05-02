#!/bin/bash

for layer_name in $(aws lambda list-layers --query 'Layers[].LayerName' --output text); do
  latest_version=$(aws lambda list-layer-versions --layer-name $layer_name --query 'LayerVersions[0].Version')
  echo "$layer_name: $latest_version"
done

