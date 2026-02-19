# Application Load Balancer
resource "aws_lb" "codedeploy_alb" {
  name               = "codedeploy-lambda-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.tf_public_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "codedeploy-lambda-alb"
  }
}

# Target Group (Lambda)
resource "aws_lb_target_group" "tg_lambda" {
  name        = "codedeploy-lambda-tg"
  target_type = "lambda"
  vpc_id      = aws_vpc.tf-vpc.id

  health_check {
    enabled = false
  }
}

# Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.codedeploy_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_lambda.arn
  }
}
