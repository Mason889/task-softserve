#!/bin/bash
###     Initializying of variables       ###
path_to_hello_html=s3://terraform-softserve-nginx/terraform/hello.html                                                          # your S3-bucket path to hello.html file
path_to_nginx_config=s3://terraform-softserve-nginx/terraform/nginx		                                            	# your S3-bucket path to nginx configuration file 
###             Commands                 ###
lsof /var/lib/dpkg/lock
lsof /var/lib/apt/lists/lock
lsof /var/cache/apt/archives/lock
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock
sudo dpkg --configure -a
sudo apt-get update
#sudo apt-get upgrade
sudo apt install -y --allow-unauthenticated nginx
sudo aws s3 cp $path_to_hello_html /var/www/html 
sudo rm -rf /etc/nginx/sites-enabled/*
sudo aws s3 cp $path_to_nginx_config /etc/nginx/sites-enabled/
sudo nginx -s reload
