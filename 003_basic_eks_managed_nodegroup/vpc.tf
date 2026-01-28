resource "aws_vpc" "tf-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "tf-vpc-example"
    }
}

data "aws_availability_zones" "tf-az" {
  state = "available"
}

resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "tf-igw"
  }
}

# ----------------------- Public NAT X 3 ------------------------------

# NAT에 할당할 Elastic IP 생성
resource "aws_eip" "nat_eip" {
  count = 2
  tags = {
    Name = "EIP for NAT Gateway ${count.index + 1}"
  }
}

# 가용영역 별 NAT Gateway 생성
resource "aws_nat_gateway" "nat_gateway" {
  count = 2
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.tf_public_subnet[count.index].id

  tags = {
    Name = "NAT Gateway ${count.index + 1}"
  }
}

# -----------------------------------------------------

resource "aws_subnet" "tf_public_subnet" {
  count = 2
  vpc_id            = aws_vpc.tf-vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.tf-az.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "tf_private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.tf-vpc.id
  cidr_block        = "10.0.${count.index + 3}.0/24"
  availability_zone = data.aws_availability_zones.tf-az.names[count.index]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.tf-vpc.id

  route { # 인터넷으로 나가는 라우팅
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-igw.id # 인터넷 게이트웨이
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private_route_table" {
  count = 2
  vpc_id = aws_vpc.tf-vpc.id

  route { # 인터넷으로 나가는 라우팅
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# 퍼블릭 라우팅 테이블 Association
resource "aws_route_table_association" "public_subnet_route_table_assoc" {
  count = 2
  subnet_id      = aws_subnet.tf_public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# 프라이빗 라우팅 테이블 Association
resource "aws_route_table_association" "private_subnet_route_table_assoc" {
  count = 2
  subnet_id      = aws_subnet.tf_private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}