#!/bin/bash


deploy_id=$(aws deploy create-deployment --application-name laravel --deployment-config-name CodeDeployDefault.AllAtOnce --deployment-group-name laravelproject --s3-location bucket=elson-testing,bundleType=zip,key=app/laravel.zip --region us-east-2 --output text)
while :
    do
        deploystatus=$(aws deploy get-deployment --deployment-id $deploy_id --query "deploymentInfo.[status]"  --region us-east-2 --output text)
        if [ "$deploystatus" = "Succeeded" ]
           then
            echo "Deployment $deploy_id is now $deploystatus"
            echo ""
            break
        elif [ "$deploystatus" = "Failed" ]
            then
            echo "Deployment $deploy_id is now $deploystatus"
            exit 1
        elif [ "$deploystatus" = "Stopped" ]
            then
            echo "Deployment $deploy_id is now $deploystatus"
            exit 1
        else
        echo "Deployment $deploy_id is now $deploystatus"
        fi
        sleep 10
    done


overalldeploystatus=$(aws deploy list-deployment-instances --deployment-id $deploy_id --instance-status-filter "Failed" --region us-east-2 --output text)

if [ -z "$overalldeploystatus" ]
    then
        echo "Deploy to all instances are Successful"
    else
        echo "Deploy to some instances are Failed"
        exit 1
fi
