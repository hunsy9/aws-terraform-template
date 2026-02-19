# Application Load Balancer
resource "aws_lb" "codedeploy_alb" {
  name               = "codedeploy-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.tf_public_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "codedeploy-ecs-alb"
  }
}

# Target Group 1 (Blue/Production)
resource "aws_lb_target_group" "tg_blue" {
  name        = "codedeploy-ecs-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tf-vpc.id
  target_type = "ip"

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

# Target Group 2 (Green/Test)
resource "aws_lb_target_group" "tg_green" {
  name        = "codedeploy-ecs-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tf-vpc.id
  target_type = "ip"

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

# Production Listener (Port 80)
resource "aws_lb_listener" "prod_listener" {
  load_balancer_arn = aws_lb.codedeploy_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_blue.arn
  }
}

# Test Listener (Port 8080) - Used by CodeDeploy for Green traffic verification
resource "aws_lb_listener" "test_listener" {
  load_balancer_arn = aws_lb.codedeploy_alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_green.arn
  }
}
