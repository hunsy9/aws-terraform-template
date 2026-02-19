
# ----------------------- Public NAT X 3 ------------------------------

# NAT에 할당할 Elastic IP 생성
resource "aws_eip" "nat_eip" {
  count = 3
  tags = {
    Name = "EIP for NAT Gateway ${count.index + 1}"
  }
}

# 가용영역 별 NAT Gateway 생성
resource "aws_nat_gateway" "nat_gateway" {
  count = 3
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "NAT Gateway ${count.index + 1}"
  }
}