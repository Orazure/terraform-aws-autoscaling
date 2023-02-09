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

// security group proxy


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
