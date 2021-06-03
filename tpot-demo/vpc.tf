# declare a VPC
resource "aws_vpc" "tpot" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "tf-tpot-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.tpot.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "tpot_igw" {
  vpc_id = aws_vpc.tpot.id

  tags = {
    Name = "TPOT VPC - Internet Gateway"
  }
}

resource "aws_route_table" "tpot_us_east_1a_public" {
    vpc_id = aws_vpc.tpot.id

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
    route_table_id = aws_route_table.tpot_us_east_1a_public.id
}
