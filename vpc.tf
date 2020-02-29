resource "aws_vpc" "jr_vpc" {
  cidr_block = "172.31.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "sub_nat_gateway1b" {
	vpc_id				= aws_vpc.jr_vpc.id
	cidr_block				= "172.31.1.0/24"
	map_public_ip_on_launch 	= true
	availability_zone		= "us-east-1b"
}

resource "aws_subnet" "sub_nat_gateway1c" {
	vpc_id				= aws_vpc.jr_vpc.id
	cidr_block				= "172.31.2.0/24"
	map_public_ip_on_launch 	= true
	availability_zone		= "us-east-1c"
}

resource "aws_subnet" "ec2_hosts1b" {
	vpc_id				= aws_vpc.jr_vpc.id
	cidr_block				= "172.31.3.0/24"
	map_public_ip_on_launch 	= false
	availability_zone		= "us-east-1b"
}

resource "aws_subnet" "ec2_hosts1c" {
	vpc_id				= aws_vpc.jr_vpc.id
	cidr_block				= "172.31.4.0/24"
	map_public_ip_on_launch 	= false
	availability_zone		= "us-east-1c"
}

resource "aws_eip" "eip_zone_1b" {
  vpc = true
}

resource "aws_eip" "eip_zone_1c" {
  vpc = true
}
