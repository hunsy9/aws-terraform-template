resource "aws_eks_cluster" "tf-cluster" {
    name = "tf-cluster"

    access_config {
        authentication_mode = "API_AND_CONFIG_MAP" # 액세스 엔트리와 aws-auth Configmap 모두 사용 가능하도록
    }

    role_arn = aws_iam_role.cluster.arn

    vpc_config {
        # API Server Endpoint는 퍼블릭/프라이빗 모두 사용
        endpoint_private_access = true
        endpoint_public_access = true

        subnet_ids = [ # NAT 라우팅이 있는 Private 서브넷만
            aws_subnet.tf_private_subnet[0].id, 
            aws_subnet.tf_private_subnet[1].id,
        ]
    }

    # 무조건 Cluster IAM Role 생성 이후 클러스터가 생성되도록 의존 관계 설정
    depends_on = [
        aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    ]
}

# Cluster IAM Role 생성

resource "aws_iam_role" "cluster" {
    name = "eks-cluster-iam-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                "sts:AssumeRole",
                "sts:TagSession"
                ]
                Effect = "Allow"
                Principal = {
                    Service = "eks.amazonaws.com"
                }
            },
        ]
    })
}

# Controlplane Role 부착
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}