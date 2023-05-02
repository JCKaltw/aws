#!/bin/bash

# Get list of function names
FUNCTION_NAMES=$(aws lambda list-functions --query 'Functions[*].FunctionName' --output text)

for FUNCTION_NAME in $FUNCTION_NAMES; do
    alias_version=$(aws lambda get-alias --function-name ${FUNCTION_NAME} --name dev --query 'FunctionVersion' --output text)
    all_versions=$(aws lambda list-versions-by-function --function-name ${FUNCTION_NAME} --query 'Versions[*].[Version]' --output text)
    latest_published_version=$(echo "$all_versions" | grep -v "\$LATEST" | sort -n | tail -1)
    latest_published_code_hash=$(aws lambda get-function --function-name ${FUNCTION_NAME}:${latest_published_version} --query 'Configuration.CodeSha256' --output text)
    latest_code_hash=$(aws lambda get-function --function-name ${FUNCTION_NAME}:\$LATEST --query 'Configuration.CodeSha256' --output text)

    echo ${FUNCTION_NAME}
    if [ "${latest_published_code_hash}" == "${latest_code_hash}" ]; then
        echo "    *** LATEST CODE PUBLISHED ***"
    else
        echo "    *** UNPUBLISHED CHANGES ***"
    fi
    echo "    alias_version=${alias_version}"
    echo "    latest_published_version=${latest_published_version}"
    echo "    latest_published_code_hash=${latest_published_code_hash}"
    echo "    latest_version=\$LATEST"
    echo "    latest_code_hash=${latest_code_hash}"
done
