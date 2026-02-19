resource "aws_autoscaling_group" "codedeploy_asg" {
  name                = "codedeploy-asg"
  vpc_zone_identifier = aws_subnet.tf_public_subnet[*].id
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  target_group_arns   = [aws_lb_target_group.tg_blue.arn]
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.codedeploy_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "codedeploy-ec2"
    propagate_at_launch = true
  }
}
