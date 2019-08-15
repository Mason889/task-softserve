#!/bin/bash
###	Initializying of variables	 ###
name_of_project=devops-practice-247821								# name of your GCP project
key_file=devops-practice-247821-005171c93906.json						# credential of project's service-account
gcp_service_account=testing-terraform@devops-practice-247821.iam.gserviceaccount.com		# name of project's service account 
###		Commands		 ###
sudo apt-get update
sudo apt-get install init -y nginx
sudo gcloud auth activate-service-account $gcp_service_account --key-file=$key_file --project=$name_of_project
sudo gsutil cp gs://testing-nginx/hello.html /var/www/html 
sudo rm -rf /etc/nginx/sites-enabled/*
sudo gsutil cp gs://testing-nginx/nginx /etc/nginx/sites-enabled/
sudo nginx -s reload

