resource "aws_codedeploy_app" "lambda_app" {
  compute_platform = "Lambda"
  name             = "codedeploy-lambda-bluegreen"
}

resource "aws_codedeploy_deployment_group" "lambda_dg" {
  app_name              = aws_codedeploy_app.lambda_app.name
  deployment_group_name = "codedeploy-lambda-dg"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  deployment_config_name = "CodeDeployDefault.LambdaLinear10PercentEvery1Minute"
  # For immediate shift, use:
  # deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
}
