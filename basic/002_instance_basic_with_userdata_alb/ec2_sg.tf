resource "aws_security_group" "sg_for_ec2" {
  name = "sg_for_ec2"
  description = "sg_for_ec2"
  vpc_id       = aws_vpc.tf-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_ec2" {
  security_group_id = aws_security_group.sg_for_ec2.id
  referenced_security_group_id = aws_security_group.sg_for_alb.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_ec2" {
  security_group_id = aws_security_group.sg_for_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}