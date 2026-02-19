output "s3_bucket_name" {
  value = aws_s3_bucket.artifact_bucket.id
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.ecs_app.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.ecs_dg.deployment_group_name
}

output "alb_dns_name" {
  value = aws_lb.codedeploy_alb.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.codedeploy_ecs_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}
