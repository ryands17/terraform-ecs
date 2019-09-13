# Define a vpc
resource "aws_vpc" "node_vpc" {
  cidr_block = "${var.vpc["cidr_block"]}"
  tags = {
    Name = "${var.vpc["vpc_name"]}"
  }
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "node_ig" {
  vpc_id = "${aws_vpc.node_vpc.id}"
  tags = {
    Name = "${var.vpc["internet_gateway_name"]}"
  }
}

# NAT Gateway for Private Subnets
resource "aws_eip" "node_simple_eip" {
  vpc = true
  tags = {
    Name = "${var.vpc["elastic_ip_name"]}"
  }
}

resource "aws_nat_gateway" "node_nat" {
  allocation_id = "${aws_eip.node_simple_eip.id}"
  subnet_id     = "${aws_subnet.public_subnet_1.id}"
  depends_on    = ["aws_internet_gateway.node_ig"]
  tags = {
    Name = "${var.vpc["nat_gateway"]}"
  }
}

# Public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = "${aws_vpc.node_vpc.id}"
  cidr_block        = "${element(var.vpc["cidr_blocks"], 0)}"
  availability_zone = "${var.availability_zones[0]}"
  tags = {
    Name = "${element(var.vpc["public_subnet_names"], 0)}"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = "${aws_vpc.node_vpc.id}"
  cidr_block        = "${element(var.vpc["cidr_blocks"], 1)}"
  availability_zone = "${var.availability_zones[1]}"
  tags = {
    Name = "${element(var.vpc["public_subnet_names"], 1)}"
  }
}

# Private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = "${aws_vpc.node_vpc.id}"
  cidr_block        = "${element(var.vpc["cidr_blocks"], 2)}"
  availability_zone = "${var.availability_zones[0]}"
  tags = {
    Name = "${element(var.vpc["private_subnet_names"], 0)}"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = "${aws_vpc.node_vpc.id}"
  cidr_block        = "${element(var.vpc["cidr_blocks"], 3)}"
  availability_zone = "${var.availability_zones[1]}"
  tags = {
    Name = "${element(var.vpc["private_subnet_names"], 1)}"
  }
}

# Route table for private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.node_vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.node_nat.id}"
  }
  tags = {
    Name = "${var.vpc["private_route_table_name"]}"
  }
}

# Associate the route table to private subnets
resource "aws_route_table_association" "private_rt_assn_1" {
  subnet_id      = "${aws_subnet.private_subnet_1.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "private_rt_assn_2" {
  subnet_id      = "${aws_subnet.private_subnet_2.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

# Route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.node_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.node_ig.id}"
  }
  tags = {
    Name = "${var.vpc["public_route_table_name"]}"
  }
}

# Associate the route table to public subnets
resource "aws_route_table_association" "public_rt_assn_1" {
  subnet_id      = "${aws_subnet.public_subnet_1.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "public_rt_assn_2" {
  subnet_id      = "${aws_subnet.public_subnet_2.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

# ECS Instance Security group
resource "aws_security_group" "public_sg" {
  name        = "${var.vpc["public_security_group_name"]}"
  description = "Open port 80 in this group for ALB"
  vpc_id      = "${aws_vpc.node_vpc.id}"
  # add rules ingress(inbound) and egress(outbound)
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name = "${var.vpc["public_security_group_name"]}"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "${var.vpc["private_security_group_name"]}"
  description = "Assign this SG to the EC2 instances"
  vpc_id      = "${aws_vpc.node_vpc.id}"
  # add rules ingress(inbound) and egress(outbound)
  ingress {
    from_port = 32768
    to_port   = 65535
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.public_sg.id}"
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name = "${var.vpc["private_security_group_name"]}"
  }
}
