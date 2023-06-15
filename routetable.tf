resource "aws_subnet" "nat_gateway" {
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Cloudideastar Public Subnet_NAT"
  }
}

resource "aws_internet_gateway" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Cloudideastar Internet Gateway"
  }
}

resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat_gateway.id
  }
  tags = {
    Name = "Cloudideastar Public Route Table"
  }  
}

resource "aws_route_table_association" "nat_gateway" {
  subnet_id = aws_subnet.nat_gateway.id
  route_table_id = aws_route_table.nat_gateway.id
}

#IGW RTB
resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.vpc.id


  tags = {
    Name = "IGW Route Table"
  }
}

#Firewall RTB
resource "aws_route_table" "FirewallRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat_gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.nat_gateway.id
  }

  tags = {
    Name = "Firewall Route Table"
  }
}

#Firewall Subnet associate with FirewallRT
resource "aws_route_table_association" "FirewallRT_a" {
  subnet_id      = aws_subnet.cloudideastar_firewall_subnet.id
  route_table_id = aws_route_table.FirewallRT.id
}