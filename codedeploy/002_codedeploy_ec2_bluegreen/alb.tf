# Application Load Balancer
resource "aws_lb" "codedeploy_alb" {
  name               = "codedeploy-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.tf_public_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "codedeploy-alb"
  }
}

# Target Group 1 (Blue)
resource "aws_lb_target_group" "tg_blue" {
  name     = "codedeploy-tg-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf-vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Target Group 2 (Green)
resource "aws_lb_target_group" "tg_green" {
  name     = "codedeploy-tg-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf-vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.codedeploy_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_blue.arn
  }
}
