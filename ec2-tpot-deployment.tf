resource "aws_security_group" "tpot" {
  name        = "tpot"
  description = "T-Pot Honeypot"
  vpc_id      = aws_vpc.sandbox.id
  ingress {
    from_port   = 0
    to_port     = 64000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 64000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 64294
    to_port     = 64294
    protocol    = "tcp"
    cidr_blocks = var.ADMIN_IP
  }
  ingress {
    from_port   = 64295
    to_port     = 64295
    protocol    = "tcp"
    cidr_blocks = var.ADMIN_IP
  }
  ingress {
    from_port   = 64297
    to_port     = 64297
    protocol    = "tcp"
    cidr_blocks = var.ADMIN_IP
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "T-Pot"
  }
}


resource "aws_instance" "tpot" {
  ami           = var.TPOT_AMI[var.EC2_REGION]
  instance_type = var.TPOT_INSTANCE_TYPE
  key_name      = var.KEY_PAIR
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "T-Pot Honeypot"
    Defender = "false"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }
  user_data                   = templatefile("../cloud-init.yaml", { timezone = var.timezone, password = var.linux_password, tpot_flavor = var.tpot_flavor, web_user = var.web_user, web_password = var.web_password })
  vpc_security_group_ids      = [aws_security_group.tpot.id]
  associate_public_ip_address = true
}



output "Admin_UI" {
  value = "https://${aws_instance.tpot.public_dns}:64294/"
}

output "SSH_Access" {
  value = "ssh -i {private_key_file} -p 64295 admin@${aws_instance.tpot.public_dns}"
}

output "Web_UI" {
  value = "https://${aws_instance.tpot.public_dns}:64297/"
}