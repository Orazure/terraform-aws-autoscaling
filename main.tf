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

### Module Main
resource "aws_lb_target_group" "alb-tp-public-tg" {
  name = "${var.app_name}-alb-tp-public-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc-tp.vpc_id
  target_type = "instance"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/health"
  }

  tags = {
    Name = "${var.app_name}-alb-http"
  }
}

// use to 443


resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.alb-tp-public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb-tp-public-tg.arn}"
  }
}



resource "aws_launch_template" "webserver_on_nginx_temp" {
  name = "webserver-on-nginx_temp"
  image_id = "ami-0fb6823b37110645b"
  instance_type = "t2.micro"
  key_name = var.key
  network_interfaces {
    security_groups = [aws_security_group.asg-tp.id]
  }

  tags = {
    Name = "${var.app_name}-webserver-on-nginx-temp"
  }

}

resource "aws_autoscaling_group" "ASGwebserver_on_nginx"{
  name = "${var.app_name}-webserver-on-nginx"
 
  target_group_arns = [aws_lb_target_group.alb-tp-public-tg.arn]
  vpc_zone_identifier = module.vpc-tp.private_subnets
  min_size = 1
  max_size = 2

   launch_template {
    id = "${aws_launch_template.webserver_on_nginx_temp.id}"
    version = "$Latest"
  }
}



