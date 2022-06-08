#!/bin/bash
sudo amazon-linux-extras install nginx1
cd /usr/share/nginx/html
mv index.html index_backup.html
aws s3 sync s3://tiange-s3-web-hosting/unicorn-web-hosting/  /usr/share/nginx/html/  --region cn-north-1
chmod 755 *
chmod 755 css/
chmod 755 fonts/
chmod 755 images/
chmod 755 js/
sudo service nginx start
