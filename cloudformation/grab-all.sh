#!/bin/bash

# Check if current directory exists
if [ -d "./current" ]; then
  # If it does, compute timestamp based on oldest creation time of JSON files
  OLDEST_FILE=$(ls -tU ./current/*.json | tail -1 | xargs -n1)
  TIMESTAMP=$(date -u -r "$OLDEST_FILE" +"%Y-%m-%d:%H:%M:%S")
  # Rename current directory to previous_${timestamp}
  mv ./current ./previous_${TIMESTAMP}
fi

current_time=$(date +"%A, %B %d, %Y, at %l:%M%P %Z" | sed 's/ 0/ /g; s/A/am/; s/P/pm/')
echo "Executing grab-all.sh  - ${current_time}"

# Set up new current directory
mkdir ./current

# Export EC2 instances
echo "Exporting EC2 instances"
aws ec2 describe-instances --query 'Reservations[].Instances[]' > ./current/ec2.json

# Export VPCs
echo "Exporting VPCs"
aws ec2 describe-vpcs --query 'Vpcs[]' > ./current/vpcs.json

# Export Lambda functions
echo "Exporting Lambda functions"
aws lambda list-functions --query 'Functions[]' > ./current/lambda.json

# Export IAM security groups
echo "Exporting IAM security groups"
aws ec2 describe-security-groups --query 'SecurityGroups[]' > ./current/security-groups.json

# Export RDS instances
echo "Exporting RDS instances"
aws rds describe-db-instances --query 'DBInstances[]' > ./current/rds.json

# Export DynamoDB tables
echo "Exporting DynamoDB tables"
./get-dynamo-tables.sh > ./current/dynamo-tables.json
