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