
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

resource "aws_security_group" "asg-tp" {
  name        = "${var.app_name}-asg-tp"
  description = "Allow inbound traffic from the Internet"
  vpc_id      = module.vpc-tp.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }   
}

resource "aws_security_group_rule" "allowHTTP8080ASG" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.asg-tp.id
}

resource "aws_security_group_rule" "allow80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
security_group_id = aws_security_group.asg-tp.id
}


// allow 443
resource "aws_security_group_rule" "allow443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.asg-tp.id
}

resource "aws_security_group_rule" "allowSSH" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.asg-tp.id
}



