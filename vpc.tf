resource "aws_vpc" "default" {
  cidr_block = "172.31.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "nat_gateway1" {
	vpc_id				= "${aws_vpc.default.id}"
	cidr_block				= "172.31.1.0/24"
	map_public_ip_on_launch 	= true
	availability_zone		= "us-east-1b"
}

resource "aws_subnet" "nat_gateway2" {
	vpc_id				= "${aws_vpc.default.id}"
	cidr_block				= "172.31.2.0/24"
	map_public_ip_on_launch 	= true
	availability_zone		= "us-east-1c"
}
