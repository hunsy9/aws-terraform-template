terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:ap-northeast-2:619071317667:cluster/tf-cluster"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}