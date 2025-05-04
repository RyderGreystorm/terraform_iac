resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

#subnets => public and private subnets
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  count = length(var.public_subnet_cidrs)
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-subnet-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name =  "${var.cluster_name}-private-subnet-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

 # GATWAYS
 # Internet Gateway for public subnets
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "eip" {
  count = length((var.private_subnet_cidrs))
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat-eip-${count.index + 1}"
  }
}

# NAT Gateway for private subnets
resource "aws_nat_gateway" "nat_gw" {
  count = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.private[count.index].id

  tags = {
    Name = "${var.cluster_name}-nat-gateway-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.gw]
}

 # ROUTE TABBLES
# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.cluster_name}-public-route-table"
  }
}

# private route table for private subnets
resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_nat_gateway.nat_gw.id[count.index].id
  }

  tags = {
    Name = "${var.cluster_name}-private-route-table-${count.index + 1}"
  }
}

# ROUTE  TABLE ASSOCIATIONS
# Associate public subnets with the route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate private subnets with the route table
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}