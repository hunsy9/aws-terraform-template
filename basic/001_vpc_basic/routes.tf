# ----------------------- Public Routing Table ------------------------------

# 퍼블릭 서브넷에 연결할 라우팅 테이블 생성
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

# 퍼블릭 라우팅 테이블 Association
resource "aws_route_table_association" "public_subnet_route_table_assoc" {
  count          = 3
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# ----------------------- Private Routing Table ------------------------------

# 프라이빗 서브넷에 연결할 라우팅 테이블 생성
resource "aws_route_table" "private_route_table" {
  count = 3
  vpc_id = aws_vpc.tf-vpc.id

  route { # 인터넷으로 나가는 라우팅
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[count.index].id # NAT 게이트웨이
  }

  tags = {
    Name = "Private Route Table ${count.index + 1}"
  }
}

# 프라이빗 라우팅 테이블 Association
resource "aws_route_table_association" "private_subnet_route_table_assoc" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

# ----------------------- No Internet Routing Table ------------------------------

# No Internet 서브넷에 연결할 라우팅 테이블 생성
resource "aws_route_table" "no_internet_route_table" {
  vpc_id = aws_vpc.tf-vpc.id

  route { # 라우팅 -> local
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "No Internet Route Table"
  }
}

# No Internet 라우팅 테이블 Association
resource "aws_route_table_association" "no_internet_subnet_route_table_assoc" {
  count          = 3
  subnet_id      = aws_subnet.no_internet_subnet[count.index].id
  route_table_id = aws_route_table.no_internet_route_table.id
}