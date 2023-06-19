#VPC_CC
resource "aws_vpc" "vpc_cc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc-cc"

  }
}

# Configuration section for internet gateway
resource "aws_internet_gateway" "internet_gateway1" {
  vpc_id = aws_vpc.vpc_cc.id

  tags ={
    Name = "IGW1"
  }
}

# Subnet1
resource "aws_subnet" "public_subnet1" {
 
  cidr_block        = "10.1.0.0/24"
  vpc_id            = aws_vpc.vpc_cc.id
    tags = {
    Name = "public-subnet-1"
}
}

# Configuration section for route table  subnet
resource "aws_route_table" "public_subnet1" {
  vpc_id = aws_vpc.vpc_cc.id
  tags = {
    "Name" = "public-rt1"
  }

} 

# Create route table subnet association
resource "aws_route_table_association" "public_subnet_association1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_subnet1.id
}


# Configuration section for default route to internet from public subnet
resource "aws_route" "default_route_public_subnet1" {
  route_table_id         = aws_route_table.public_subnet1.id
  destination_cidr_block = var.default_route
  gateway_id             = aws_internet_gateway.internet_gateway1.id
}


# Create route to transist gateway in route table 
resource "aws_route" "tgw-route-1" {
  route_table_id         = aws_route_table.public_subnet1.id
  destination_cidr_block = "10.2.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.hsbc-tgw.id
  depends_on = [
    aws_ec2_transit_gateway.hsbc-tgw
  ]
}


#VPC_CP
resource "aws_vpc" "vpc_cp" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = "spoke_vpc_cp"
}
}

# Configuration section for internet gateway
resource "aws_internet_gateway" "internet_gateway2" {
  vpc_id = aws_vpc.vpc_cp.id

  tags ={
    Name = "IGW2"
  }
}

# public subnet2
resource "aws_subnet" "public_subnet2" {
  cidr_block        = "10.2.0.0/24"
  vpc_id            = aws_vpc.vpc_cp.id
    tags = {
    Name = "public-subnet-2"
}
}


# Configuration section for route table public subnet2
resource "aws_route_table" "public_subnet2" {
  vpc_id = aws_vpc.vpc_cp.id
  tags = {
    "Name" = "public-rt2"
  }

} 

# Create route table public subnet association
resource "aws_route_table_association" "public_subnet_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_subnet2.id
}


# Configuration section for default route to internet from public subnet
resource "aws_route" "default_route_public_subnet2" {
  route_table_id         = aws_route_table.public_subnet2.id
  destination_cidr_block = var.default_route
  gateway_id             = aws_internet_gateway.internet_gateway2.id
}

# Create route to transist gateway in route table
resource "aws_route" "tgw-route-2" {
  
  route_table_id         = aws_route_table.public_subnet2.id
  destination_cidr_block = "10.1.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.hsbc-tgw.id
  depends_on = [
    aws_ec2_transit_gateway.hsbc-tgw
  ]
}


resource "aws_ec2_transit_gateway" "hsbc-tgw" {
 
  description                     = "Transit Gateway testing scenario with 2 VPCs, subnets each"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = {
    Name        = "test-tgw"
    environment = "prd"
  }
}




resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_cc_attachment" {
 
  subnet_ids         = [aws_subnet.public_subnet1.id]
  transit_gateway_id = aws_ec2_transit_gateway.hsbc-tgw.id
  vpc_id             = aws_vpc.vpc_cc.id
  tags = {
    "Name" = "transit-gateway-attachment1"
  }
}

## Attachement of VPC2 from AWS production Account
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_cp_attachment" {
 
  subnet_ids         = [aws_subnet.public_subnet2.id]
  transit_gateway_id = aws_ec2_transit_gateway.hsbc-tgw.id
  vpc_id             = aws_vpc.vpc_cp.id
  tags = {
    "Name" = "transit-gateway-attachment2"
  }
}

# Create security Groups with ingress and egress rules
# Create SG1

resource "aws_security_group" "sg1" {
  name        = "sg1"
  description = "allow ssh from internet and icmp from 10.2.0.0/24"
  vpc_id      = aws_vpc.vpc_cc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 
    to_port     = 0 
    protocol    = "icmp"
    cidr_blocks = ["10.2.0.0/24"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

 
  tags = {
    Name = "sg1"
    
  }
}

# Create SG2


resource "aws_security_group" "sg2" {
  name        = "sg2"
  description = "allow ssh from internet and icmp from 10.1.0.0/24"
  vpc_id      = aws_vpc.vpc_cp.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 
    to_port     = 0 
    protocol    = "icmp"
    cidr_blocks = ["10.1.0.0/24"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = "sg2"
    
  }
}