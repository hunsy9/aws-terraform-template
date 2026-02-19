# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-lambda"
  description = "Security group for CodeDeploy Lambda ALB"
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
    Name = "alb-sg-lambda"
  }
}

# Lambda Security Group (for VPC attachment)
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Security group for Lambda Function"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg"
  }
}
