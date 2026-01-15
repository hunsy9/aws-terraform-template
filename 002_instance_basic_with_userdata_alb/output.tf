output "alb_endpoint" {
    value = aws_lb.test_alb.dns_name
}