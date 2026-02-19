data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/app/index.js"
  output_path = "${path.module}/app/index.zip"
}

resource "aws_lambda_function" "example" {
  filename      = "${path.module}/app/index.zip"
  function_name = "codedeploy-lambda-bg"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs20.x"
  publish = true

  vpc_config {
    subnet_ids         = aws_subnet.tf_private_subnet[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = {
    Name = "codedeploy-lambda-bg"
  }
}

resource "aws_lambda_alias" "prod" {
  name             = "prod"
  description      = "Production alias"
  function_name    = aws_lambda_function.example.function_name
  function_version = aws_lambda_function.example.version
}

# Allow ALB to invoke Lambda
resource "aws_lambda_permission" "alb_invoke" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  qualifier     = aws_lambda_alias.prod.name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.tg_lambda.arn
}

# ALB Target Group Attachment (to Alias)
resource "aws_lb_target_group_attachment" "lambda_tg_attach" {
  target_group_arn = aws_lb_target_group.tg_lambda.arn
  target_id        = aws_lambda_alias.prod.arn
  depends_on       = [aws_lambda_permission.alb_invoke]
}
