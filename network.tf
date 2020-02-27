resource "aws_internet_gateway" "default" {
	vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "default" {
	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.default.id}"
	}
}

resource "aws_route_table_association" "table1" {
	subnet_id = "${aws_subnet.nat_gateway1.id}"
	route_table_id = "{aws_rtb.default.id}"
}

resource "aws_route_table_association" "table2" {
	subnet_id = "${aws_subnet.nat_gateway2.id}"
	route_table_id = "{aws_rtb.default.id}"
}


resource "aws_security_group" "ssh-allowed" {
	vpc_id = "${aws_vpc.default.id}"

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

	// This is for NGINX
	ingress {
		from_port	= 80
		to_port	= 80
		protocol	= "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}