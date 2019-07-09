# Deploying a Scalable Web Service using AWS and Terraform.
## Creating a Load Balancing between a cluster of web services on AWS with Terraform

This repo is using `ELB` **Elastic Load Balancing** with `ASG` **Auto Scaling Group** to provide highly available and efficient web servers

## Deploying a Cluster of Web Servers

We will use `ASG` to launch a `cluster` of `EC2` Instances,  monitoring the health of each Instance, replacing failed Instances, and adjusting the size of the cluster in response to load.

* `ASG` distributes the `EC2` instances across multiple `availability zones` 
  * each `AWS account` has access to different set of `Availability zones`, in this repo, I've chosen `all` availability zones available in the account

## Deploying a Load Balancer

After deploying the `ASG` we'll have serveral different servers, each with its own ip address, but we need to give the end users only a single IP to hit, and for this we're going to deploy a load balancer to distribute traffic accross the servers and to give the end users a single dns name which is the the load balancer dns name

## Deploying the app

A simple flask app is created to return the desired message "Hello World!" as response along with the instance-id required in the header.
This app is deployed using the userdata in the instances.

---

# Install Terraform On Linux

For other platforms to install Terraform download the binray from the download page

https://www.terraform.io/downloads.html

```bash
yum -y install unzip

cd /tmp
wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
unzip terraform_0.11.14_linux_amd64.zip -d /usr/bin/

terraform -v
```

---

# Usage

Add AWS `access key` & `secret key` as Environment Variables, In this way we're NOT setting them permanently, we'll need to run these commands again whenever we reopen the terminal

```bash
export AWS_ACCESS_KEY_ID=<access key>
export AWS_SECRET_ACCESS_KEY=<secret key>
```


```bash
yum -y install git
```



```bash
git clone https://github.com/jyotibhanot30/global-network-coding-challenge.git
cd global-network-coding-challenge/

# Downloading the Plugin for the AWS provider
terraform init
```

* See what's terraform is planning to do before really doing it

```bash
terraform plan
```



* build the terraform project

```bash
terraform apply
# yes | if you want to proceed
```

* destroy what you've built

```bash
terraform destroy
# yes | if you want to proceed
```


## TESTS
Once terraform runs fine, we get the ELB endpoint as the output.

```bash
curl -i <ELB Endpoint>
```
