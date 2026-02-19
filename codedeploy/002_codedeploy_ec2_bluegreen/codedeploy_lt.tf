data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_launch_template" "codedeploy_lt" {
  name = "codedeploy-lt"

  disable_api_stop        = false
  disable_api_termination = false

  ebs_optimized = true

  image_id = data.aws_ami.amazon_linux_2023.id

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "codedeploy-ec2"
    }
  }

  user_data = filebase64("${path.module}/example.sh")
}
