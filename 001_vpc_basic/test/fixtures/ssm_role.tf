# ssm 접속용 인스턴스 프로파일 생성
resource "aws_iam_role" "ssm_instance_test_role" {
  name = "ssm_instance_test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach-ssm-role" {
  role = aws_iam_role.ssm_instance_test_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.ssm_instance_test_role.name
}