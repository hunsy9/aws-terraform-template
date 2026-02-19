output "s3_bucket_name" {
  value = aws_s3_bucket.artifact_bucket.id
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.lambda_app.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.lambda_dg.deployment_group_name
}

output "alb_dns_name" {
  value = aws_lb.codedeploy_alb.dns_name
}

output "lambda_function_name" {
  value = aws_lambda_function.example.function_name
}

output "lambda_alias_name" {
  value = aws_lambda_alias.prod.name
}
