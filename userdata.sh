#!/bin/bash -v
set -ex
sudo yum update -y 
sudo yum install python-pip git -y
pip install Flask requests 
git clone https://github.com/jyotibhanot30/global-network-coding-challenge.git
nohup python global-network-coding-challenge/app.py &


