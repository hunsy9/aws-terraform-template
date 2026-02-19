# ----------------------- Public/Private Subnet ------------------------------

# AZ 3곳에 퍼블릭 서브넷 생성
resource "aws_subnet" "public_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "10.0.${count.index * 2}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet AZ ${count.index + 1}"
  }
}

# AZ 3곳에 프라이빗 서브넷 생성
resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.tf-vpc.id
  cidr_block        = "10.0.${count.index * 2 + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Private Subnet AZ ${count.index + 1}"
  }
}

# AZ 3곳에 폐쇄 서브넷 생성
resource "aws_subnet" "no_internet_subnet" {
  count             = 3
  vpc_id            = aws_vpc.tf-vpc.id
  cidr_block        = "10.0.${count.index + 6}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "No Internet Subnet AZ ${count.index + 1}"
  }
}