# Private 환경에서 ssm 연결을 위해서 ssm, ec2, ec2messages, ssmmessages 및 s3의 VPC 엔드포인트가 필요합니다.
# (Ref) https://docs.aws.amazon.com/ko_kr/prescriptive-guidance/latest/patterns/connect-to-an-amazon-ec2-instance-by-using-session-manager.html

# ssm, ec2, ec2messages, ssmmessages endpoint를 위한 SG
resource "aws_security_group" "sg_for_vpc_endpoint" {
  name = "sg_for_vpc_endpoint"
  description = "sg_for_vpc_endpoint"
  vpc_id       = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.sg_for_vpc_endpoint.id
  cidr_ipv4 = module.vpc.vpc_cidr
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_for_vpc_endpoint.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ------------------------------------------------------------------------

# s3 gateway endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.ap-northeast-2.s3"
  route_table_ids = [module.vpc.no_internet_route_table_id]
}

locals {
  vpc_endpoints = ["ec2", "ssm", "ssmmessages", "ec2messages"]
  subnet_ids = module.vpc.no_internet_subnet_ids
}

# vpc endpoint 선언
resource "aws_vpc_endpoint" "vpc_endpoints" {
  for_each = toset(local.vpc_endpoints)

  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-2.${each.value}"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sg_for_vpc_endpoint.id
  ]

  private_dns_enabled = true
  

  subnet_ids = local.subnet_ids

  tags = {
    Name = "${each.value}-endpoint"
  }
}
