#!/bin/bash
sudo apt-get update
sudo apt-get install init -y nginx
gcloud auth activate-service-account testing-terraform@devops-practice-247821.iam.gserviceaccount.com --key-file=devops-practice-247821-005171c93906.json --project=devops-practice-247821
sudo gsutil cp gs://testing-nginx/hello.html /var/www/html 
sudo rm -rf /etc/nginx/sites-enabled/*
sudo gsutil cp gs://testing-nginx/nginx /etc/nginx/sites-enabled/
sudo nginx -s reload

