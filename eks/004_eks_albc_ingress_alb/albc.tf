resource "helm_release" "aws_lbc" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set = [
    {
      name  = "clusterName"
      value = data.aws_eks_cluster.this.name
    },
    {
      name  = "region"
      value = data.aws_eks_cluster.this.region
    },
    {
      name  = "vpcId"
      value = data.aws_eks_cluster.this.vpc_config[0].vpc_id
    },
  ]
}