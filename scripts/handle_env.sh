#!/bin/bash

# Retrieve the parameter value
LARAVEL_ENV=$(aws ssm get-parameter --name "laravel_env" --query "Parameter.Value" --output text)

# Create the target directory if it does not exist
mkdir -p /var/www/laravel

# Create or update the .env file with the parameter value
echo "LARAVEL_ENV=$LARAVEL_ENV" > /var/www/laravel/.env
