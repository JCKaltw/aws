#!/bin/bash

table_names_json=$(aws dynamodb list-tables --query 'TableNames[]')
table_names=$(echo "$table_names_json" | jq -r '.[]')

for table_name in $table_names; do
  echo "Exporting table: $table_name"
  aws dynamodb describe-table --table-name "$table_name" > ./current/"${table_name}.json"
done

