resource "aws_security_group" "sg_for_alb" {
  name = "sg_for_alb"
  description = "sg_for_alb"
  vpc_id       = aws_vpc.tf-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.sg_for_alb.id
  # cidr_ipv4 = "0.0.0.0/0"
  prefix_list_id = "pl-04d32cf3e97374098"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_for_alb.id
  cidr_ipv4         = aws_vpc.tf-vpc.cidr_block
  ip_protocol       = "-1"
}