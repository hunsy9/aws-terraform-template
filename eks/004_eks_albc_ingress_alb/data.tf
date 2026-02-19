data "aws_eks_cluster" "this" {
  name = "tf-cluster"
}

data "aws_eks_cluster_auth" "this" {
  name = "tf-cluster"
}