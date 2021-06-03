variable "ec2_region" {
  description = "AWS region to launch servers"
  default     = "us-east-1"
}

variable "key_pair" {
  type = string
  default = "nv-pan"
}