resource "aws_lb"   "alb-tp-public"{
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-tp.id]
  subnets            = module.vpc-tp.public_subnets
  name = "${var.app_name}-alb-public"
  


  tags = {
    Name = "${var.app_name}-alb-public"
    Tier="public"
  }
}


### Module Main
resource "aws_lb_target_group" "alb-tp-public-tg" {
  name = "${var.app_name}-alb-tp-public-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc-tp.vpc_id
  
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


resource "aws_security_group" "alb-tp" {
  name        = "${var.app_name}-alb-tp"
  description = "Allow inbound traffic from the Internet"
  vpc_id      = module.vpc-tp.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "allow80ALB" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-tp.id
}

resource "aws_security_group_rule" "allow8080ALB" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb-tp.id
}
