resource "aws_igw" "default" {
	vpc_id = "${aws_vpc.default.id}"
}

resource "aws_rtb" "default" {
	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_igw.default.id}"
	}
}

resource "aws_rtb_association1" "default" {
	subnet_id = "${nat_gateway1_subnet.default.id}"
	route_table_id = "{aws_rtb.default.id}"
}

resource "aws_rtb_association2" "default" {
	subnet_id = "${nat_gateway2_subnet.default.id}"
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