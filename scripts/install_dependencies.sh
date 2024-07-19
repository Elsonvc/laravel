#!/bin/bash
sudo chown -R ec2-user:ec2-user /home/ec2-user/laravel
cd /home/ec2-user/laravel
composer install --no-progress --prefer-dist --optimize-autoloader
# Install Node.js and npm
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
sudo yum install -y nodejs

# Install PHP dependencies
composer install --no-progress --prefer-dist --optimize-autoloader

# Install Node.js dependencies
npm install


