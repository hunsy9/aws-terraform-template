# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-ecs"
  description = "Security group for CodeDeploy ECS ALB"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    prefix_list_ids = ["pl-04d32cf3e97374098"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-ecs"
  }
}

# ECS Security Group (Fargate)
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS Fargate Service"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}
