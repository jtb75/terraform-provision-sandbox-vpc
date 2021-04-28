# declare a VPC
resource "aws_vpc" "sandbox" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "tf-sandbox-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.sandbox.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "sandbox_igw" {
  vpc_id = aws_vpc.sandbox.id

  tags = {
    Name = "Sandbox VPC - Internet Gateway"
  }
}

resource "aws_route_table" "sandbox_us_east_1a_public" {
    vpc_id = aws_vpc.sandbox.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sandbox_igw.id
    }

    tags = {
        Name = "Public Subnet Route Table"
    }
}

resource "aws_route_table_association" "sandbox_us_east_1a_public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.sandbox_us_east_1a_public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
  description = "Allow SSH inbound connections"
  vpc_id = aws_vpc.sandbox.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_sg"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http_sg"
  description = "Allow HTTP inbound connections"
  vpc_id = aws_vpc.sandbox.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_sg"
  }
}

resource "aws_flow_log" "example" {
  iam_role_arn    = aws_iam_role.example.arn
  log_destination = aws_cloudwatch_log_group.example.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.example.id
}

resource "aws_cloudwatch_log_group" "example" {
  name = "example"
}

resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = "example"
  role = aws_iam_role.example.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
