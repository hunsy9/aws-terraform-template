output "private_subnet_instance" {
  value = aws_instance.private_subnet_instance.id
}

output "no_internet_subnet_instance" {
  value = aws_instance.no_internet_subnet_instance.id
}