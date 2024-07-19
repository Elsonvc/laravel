#!/bin/bash
sudo chown -R ec2-user:ec2-user /home/ec2-user/laravel
cd /home/ec2-user/laravel
composer install --no-progress --prefer-dist --optimize-autoloader


