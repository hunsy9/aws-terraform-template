output "alb_endpoint" {
    value = aws_lb.test_alb.dns_name
}

output "tg_arn" {
    value = aws_lb_target_group.test_alb_tg.arn
}

output "instance_id" {
    value = aws_instance.tg_instance[*].id
}