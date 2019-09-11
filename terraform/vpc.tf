# Define a vpc
resource "aws_vpc" "node_simple_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "node-simple-vpc"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "node_simple_ig" {
  vpc_id = "${aws_vpc.node_simple_vpc.id}"
  tags = {
    Name = "node-simple-ig"
  }
}

# Public subnet
resource "aws_subnet" "node_simple_public" {
  vpc_id            = "${aws_vpc.node_simple_vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.availability_zones[0]}"
  tags = {
    Name = "node-simple-public-subnet"
  }
}

resource "aws_subnet" "node_simple_public2" {
  vpc_id            = "${aws_vpc.node_simple_vpc.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.availability_zones[1]}"
  tags = {
    Name = "node-simple-public-subnet"
  }
}

# Private subnet
resource "aws_subnet" "node_simple_private" {
  vpc_id            = "${aws_vpc.node_simple_vpc.id}"
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.availability_zones[2]}"
  tags = {
    Name = "node-simple-private-subnet"
  }
}

# Route table for public subnet
resource "aws_route_table" "node_simple_rt" {
  vpc_id = "${aws_vpc.node_simple_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.node_simple_ig.id}"
  }
  tags = {
    Name = "node-simple-rt"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "node_simple_rt_assn" {
  subnet_id      = "${aws_subnet.node_simple_public.id}"
  route_table_id = "${aws_route_table.node_simple_rt.id}"
}

# ECS Instance Security group
resource "aws_security_group" "node_simple_public_sg" {
  name        = "node-simple-public-sg"
  description = "Open port 80 in this group for ALB"
  vpc_id      = "${aws_vpc.node_simple_vpc.id}"
  # add rules ingress(inbound) and egress(outbound)
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name = "node-simple-public-sg"
  }
}

resource "aws_security_group" "node_simple_private_sg" {
  name        = "node-simple-private-sg"
  description = "Assign this SG to the EC2 instances"
  vpc_id      = "${aws_vpc.node_simple_vpc.id}"
  # add rules ingress(inbound) and egress(outbound)
  ingress {
    from_port = 32768
    to_port   = 65535
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.node_simple_public_sg.id}"
    ]
  }
  tags = {
    Name = "node-simple-private-sg"
  }
}
