#!/bin/bash

# Retrieve the parameter value
LARAVEL_ENV=$(aws ssm get-parameter --name "laravel_env" --query "Parameter.Value" --output text)

# Create or update the .env file with the parameter value
echo "LARAVEL_ENV=$LARAVEL_ENV" > /var/www/laravel/.env

# You can add other environment variables similarly if needed
