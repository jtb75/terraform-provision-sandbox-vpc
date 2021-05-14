provider "aws" {
  region = "var.EC2_REGION"
}

resource "random_pet" "pet_name" {
  length    = 3
  separator = "-"
}