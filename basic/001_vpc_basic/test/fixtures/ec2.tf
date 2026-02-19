module "vpc" {
  source = "../../"
}

# x86 아키텍처 AL2023 AMI 중 최신 이미지 쿼리

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Private 서브넷에 인스턴스 띄우기
resource "aws_instance" "private_subnet_instance" {
    ami = data.aws_ami.amzn-linux-2023-ami.id
    instance_type = "t3.medium"

    # ap-northeast-2a의 프라이빗 서브넷에 인스턴스 배포
    subnet_id = module.vpc.private_subnet_ids[0]

    # ssm으로 접속할 수 있도록 인스턴스 프로파일 설정
    iam_instance_profile = aws_iam_instance_profile.test_profile.name
    
    tags = {
      Name = "Private Instance"
    }
}

# No Internet 서브넷에 인스턴스 띄우기
resource "aws_instance" "no_internet_subnet_instance" {
    ami = data.aws_ami.amzn-linux-2023-ami.id
    instance_type = "t3.medium"

    # ap-northeast-2a의 퍼블릭 서브넷에 인스턴스 배포
    subnet_id = module.vpc.no_internet_subnet_ids[0]

    # ssm으로 접속할 수 있도록 인스턴스 프로파일 설정
    iam_instance_profile = aws_iam_instance_profile.test_profile.name
    
    tags = {
      Name = "Air Gapped Instance"
    }
}