output "vpc_id" {
    value = aws_vpc.tf-vpc.id
}

output "vpc_cidr" {
    value = aws_vpc.tf-vpc.cidr_block
}

output "no_internet_route_table_id" {
    value = aws_route_table.no_internet_route_table.id
}

output "public_subnet_ids" {
    description = "List of IDs of public subnets"
    value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
    description = "List of IDs of private subnets"
    value = aws_subnet.private_subnet[*].id
}

output "no_internet_subnet_ids" {
    description = "List of IDs of air-gapped subnets"
    value = aws_subnet.no_internet_subnet[*].id
}