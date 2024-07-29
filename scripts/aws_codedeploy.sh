#!/bin/bash

# Check if required environment variables are set
if [ -z "$codedeploy_application_name" ] || [ -z "$codedeploy_groupname" ] || [ -z "$aws_s3_bucket_name" ] || [ -z "$CI_PIPELINE_ID" ]; then
    echo "Error: One or more required environment variables are missing."
    exit 1
fi

deploy_id=$(aws deploy create-deployment \
    --application-name "$codedeploy_application_name" \
    --deployment-config-name CodeDeployDefault.AllAtOnce \
    --deployment-group-name "$codedeploy_groupname" \
    --s3-location bucket="$aws_s3_bucket_name",bundleType=zip,key="$CI_PIPELINE_ID.zip" \
    --region us-east-2 \
    --query 'deploymentId' \
    --output text)

echo "Created deployment with ID: $deploy_id"

while true; do
    deploystatus=$(aws deploy get-deployment \
        --deployment-id "$deploy_id" \
        --query "deploymentInfo.status" \
        --region us-east-2 \
        --output text)

    if [ "$deploystatus" = "Succeeded" ]; then
        echo "Deployment $deploy_id is now $deploystatus"
        break
    elif [ "$deploystatus" = "Failed" ]; then
        echo "Deployment $deploy_id failed with status: $deploystatus"
        exit 1
    else
        echo "Deployment $deploy_id is in status: $deploystatus"
    fi

    sleep 30
done

overalldeploystatus=$(aws deploy list-deployment-instances \
    --deployment-id "$deploy_id" \
    --instance-status-filter "Failed" \
    --region us-east-2 \
    --output text)

if [ -z "$overalldeploystatus" ]; then
    echo "Deployment to all instances was successful."
else
    echo "Deployment to some instances failed."
    exit 1
fi
