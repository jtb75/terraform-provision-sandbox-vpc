provider "aws" {
  region = var.ec2_region
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

locals {
  cluster_name = "tf-eks-${random_string.suffix.result}"
  vpc_name = "tf-eks-vpc-${random_string.suffix.result}"
}