#------AUTHOR DETAILS------#
#Name : Anil kumar challagondla
#Mail : akc.devops#gmail.com

resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "${var.projectname}-${var.environment}-vpc"
    }
  
}

# Setup public subnet
resource "aws_subnet" "public_subnets" {
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_public_subnet
  availability_zone =var.availability_zone

  tags = {
    Name = "${var.projectname}-${var.environment}-public-subnet"
  }
  
}

# Setup private subnet
resource "aws_subnet" "private_subnets" {
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_private_subnet
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.projectname}-${var.environment}-private-subnet"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.projectname}-${var.environment}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.projectname}-${var.environment}-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "public_rt_subnet_association" {
 
  subnet_id      = aws_subnet.public_subnets.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_subnets" {
  vpc_id = aws_vpc.main.id
  #depends_on = [aws_nat_gateway.nat_gateway]
  tags = {
    Name = "${var.projectname}-${var.environment}-private-rt"
  }
}

# Private Route Table and private Subnet Association
resource "aws_route_table_association" "private_rt_subnet_association" {
  
  subnet_id      = aws_subnet.private_subnets.id
  route_table_id = aws_route_table.private_subnets.id
}