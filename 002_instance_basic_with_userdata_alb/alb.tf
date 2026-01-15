# ALB

resource "aws_lb" "test_alb" {
  name               = "test-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_for_alb.id]
  subnets            = [for subnet in aws_subnet.tf_public_subnet : subnet.id]

  tags = {
    Environment = "test"
  }
}


# ALB Target Group

resource "aws_lb_target_group" "test_alb_tg" {
  name = "test-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.tf-vpc.id
}

# ALB TargetGroup Binding

resource "aws_lb_target_group_attachment" "test_alb_tg_binding" {
  
  for_each = {
    for k, v in aws_instance.tg_instance :
    k => v
  }

  target_group_arn = aws_lb_target_group.test_alb_tg.arn
  target_id = each.value.id
  port = 80
}


# ALB Listener

resource "aws_lb_listener" "test_alb_listener" {
  load_balancer_arn = aws_lb.test_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.test_alb_tg.arn
  }
}

