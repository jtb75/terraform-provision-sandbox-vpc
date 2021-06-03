variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "admin_ip" {
  default     = ["24.178.240.50/32"]
  description = "IP Address for accessing Admin Console"
}

variable "ec2_region" {
  description = "AWS region to launch servers"
  default     = "us-east-1"
}

variable "key_pair" {
  type = string
  default = "nv-pan"
}