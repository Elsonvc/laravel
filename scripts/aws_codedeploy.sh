#!/bin/bash

# Create a new deployment and get the deployment ID
deployment_id=$(aws deploy create-deployment \
  --application-name *** \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name *** \
  --s3-location bucket=***,key=app/***.zip,bundleType=zip \
  --query 'deploymentId' --output text)

# Check if the deployment ID was successfully retrieved
if [ -z "$deployment_id" ]; then
  echo "Failed to create deployment. No deployment ID returned."
  exit 1
fi

# Output the deployment ID
echo "Deployment ID: $deployment_id"

# Save the deployment ID to GitHub Actions environment file
echo "deployment_id=$deployment_id" >> $GITHUB_ENV
