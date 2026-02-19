# x86 아키텍처 AL2023 AMI 중 최신 이미지 쿼리

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "tg_instance" {
  count = 2
  region = "ap-northeast-2"
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t3.medium"
  subnet_id = aws_subnet.tf-private_subnet[count.index].id

  security_groups = [aws_security_group.sg_for_ec2.id]
  
  user_data = <<-EOF
  #!/bin/bash
  sudo dnf update -y
  sudo dnf install nginx -y
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF
  
  tags = {
    test_tags = "Test"
  }
}

