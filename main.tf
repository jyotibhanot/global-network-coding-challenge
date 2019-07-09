provider "aws" {
  region = var.region
}

resource "aws_security_group" "terraform" {
  name = "terraform"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "terraform" {
  image_id        = var.ami
  instance_type   = var.instance_type
  key_name        = "inpursuit2019"
  provisioner "file" {
    source      = "app.py"
    destination = "/tmp/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/app.py",
      "yum install python-pip -y",
      "pip install Flask requests -y",
      "nohup python /tmp/app.py &"
    ]
  } 
  security_groups = [aws_security_group.terraform.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terraform-ASG" {
  launch_configuration = aws_launch_configuration.terraform.id
  availability_zones = data.aws_availability_zones.all.names

  load_balancers = [aws_elb.terraform-elb.name]
  health_check_type = "ELB"

  max_size         = 1
  min_size         = 1
  desired_capacity = 1

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {
}

resource "aws_elb" "terraform-elb" {
  name = "terraform-elb"
  availability_zones = data.aws_availability_zones.all.names
  security_groups = [aws_security_group.terraform.id]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:80/"
    timeout = 3
    unhealthy_threshold = 2
  }
}

