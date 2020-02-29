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

resource "aws_nat_gateway" "nat_gateway1b" {
	allocation_id = aws_eip.eip_zone_1b.id
	subnet_id = aws_subnet.sub_nat_gateway1b.id
	depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway1c" {
	allocation_id = aws_eip.eip_zone_1c.id
	subnet_id = aws_subnet.sub_nat_gateway1c.id
	depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "table1b" {
	subnet_id = aws_subnet.sub_nat_gateway1b.id
	route_table_id = aws_route_table.aws_rtb_public.id
}

resource "aws_route_table_association" "table1c" {
	subnet_id = aws_subnet.sub_nat_gateway1c.id
	route_table_id = aws_route_table.aws_rtb_public.id
}

resource "aws_security_group" "ssh-allowed" {
	vpc_id = aws_vpc.jr_vpc.id

	egress {
		from_port	= 0
		to_port	= 0
		protocol	= -1
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port	= 22
		to_port	= 22
		protocol	= "tcp"

		// consider putting home address here
		cidr_blocks = ["0.0.0.0/0"]
	}

	// This is for NGINX/HTTP
	ingress {
		from_port	= 80
		to_port	= 80
		protocol	= "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}
