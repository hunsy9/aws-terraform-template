variable "admin_principal_arn" {
  type = string
}

variable "cli_admin_principal_arn" {
  type = string
}

# 콘솔 사용자에게 ClusterAdmin 권한 부여
resource "aws_eks_access_entry" "console_admin" {
  cluster_name      = aws_eks_cluster.tf-cluster.name
  principal_arn = var.admin_principal_arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "console_admin_policy" {
  cluster_name = aws_eks_cluster.tf-cluster.name
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.admin_principal_arn
  access_scope {
    type = "cluster"
  }
}

# CLI 사용자에게 ClusterAdmin 권한 부여
resource "aws_eks_access_entry" "cli_admin" {
  cluster_name      = aws_eks_cluster.tf-cluster.name
  principal_arn = var.cli_admin_principal_arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "cli_admin_policy" {
  cluster_name = aws_eks_cluster.tf-cluster.name
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.cli_admin_principal_arn
  access_scope {
    type = "cluster"
  }
}
