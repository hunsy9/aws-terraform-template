# VPC 생성
resource "aws_vpc" "tf-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "tf-vpc"
  }
}

# ----------------------- Internet Gateway ------------------------------

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "tf-igw"
  }
}

# ----------------------- Availability Zone ------------------------------

# AZ 데이터소스
data "aws_availability_zones" "available" {
  state = "available" # 현재 사용가능한 AZ만
}