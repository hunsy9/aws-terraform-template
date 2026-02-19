resource "aws_eks_addon" "pod_identity" {
  cluster_name = data.aws_eks_cluster.this.name
  addon_name   = "eks-pod-identity-agent"
}