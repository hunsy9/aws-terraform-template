output "s3_bucket_name" {
  value = aws_s3_bucket.artifact_bucket.id
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.example.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.example.deployment_group_name
}
