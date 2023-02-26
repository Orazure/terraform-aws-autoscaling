### Provider definition

provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket="terraform-state-tp"
    key="state-tp-scaling"
    region="us-east-1"
  }
}


resource "aws_launch_template" "webserver_on_nginx_temp" {
  name = "webserver-on-nginx_temp"
  image_id = "${var.nameAmiNginx}"
  instance_type = "t2.micro"
  key_name = var.key
  network_interfaces {
    security_groups = [aws_security_group.asg-tp.id]
  }

  tags = {
    Name = "${var.app_name}-webserver-on-nginx-temp"
  }

}



