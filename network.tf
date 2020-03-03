resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.jr_vpc.id
}

resource "aws_route_table" "aws_rtb_public" {
  vpc_id = aws_vpc.jr_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "aws_rtb_private_to_1b" {
  vpc_id = aws_vpc.jr_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway1b.id
  }
}

resource "aws_route_table" "aws_rtb_private_to_1c" {
  vpc_id = aws_vpc.jr_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway1c.id
  }
}

resource "aws_nat_gateway" "nat_gateway1b" {
  allocation_id = aws_eip.eip_zone_1b.id
  subnet_id     = aws_subnet.sub_nat_gateway1b.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway1c" {
  allocation_id = aws_eip.eip_zone_1c.id
  subnet_id     = aws_subnet.sub_nat_gateway1c.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "table1b" {
  subnet_id      = aws_subnet.sub_nat_gateway1b.id
  route_table_id = aws_route_table.aws_rtb_public.id
}

resource "aws_route_table_association" "table1c" {
  subnet_id      = aws_subnet.sub_nat_gateway1c.id
  route_table_id = aws_route_table.aws_rtb_public.id
}

resource "aws_route_table_association" "private1b" {
  subnet_id      = aws_subnet.ecs_hosts1b.id
  route_table_id = aws_route_table.aws_rtb_private_to_1b.id
}

resource "aws_route_table_association" "private1c" {
  subnet_id      = aws_subnet.ecs_hosts1c.id
  route_table_id = aws_route_table.aws_rtb_private_to_1c.id
}

resource "aws_security_group" "remote_management" {
  vpc_id = aws_vpc.jr_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    // consider putting home address here
    cidr_blocks = ["0.0.0.0/0"]
  }

  // This is for NGINX/HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http_allowed" {
  vpc_id = aws_vpc.jr_vpc.id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // This is for HTTP through ALB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.jr_vpc.id
}

resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 65000
  ip_address = "192.168.1.1"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = "ipsec.1"
}

resource "aws_vpn_connection_route" "home" {
  destination_cidr_block = "192.168.1.0/24"
  vpn_connection_id      = aws_vpn_connection.vpn.id
}
