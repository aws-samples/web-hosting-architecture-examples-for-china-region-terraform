#!/bin/bash
cd /home/ec2-user
curl -O https://nodejs.org/download/release/v12.22.0/node-v12.22.0-linux-x64.tar.gz > /home/ec2-user/node-v12.22.0-linux-x64.tar.gz 
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xvf node-v12.22.0-linux-x64.tar.gz -C /usr/local/lib/nodejs
export PATH=/usr/local/lib/nodejs/node-v12.22.0-linux-x64/bin:$PATH
source /etc/profile
npm install aws-sdk
curl -O https://tiange-s3-web-hosting.s3.cn-north-1.amazonaws.com.cn/unicorn-nodejs-script/index.js >/home/ec2-user/index.js
nohup node index.js &

