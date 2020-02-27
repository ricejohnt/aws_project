provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_vpc" "default" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_igw" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id	        = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_igw.default.id}"
 
resource "nat_gateway1_subnet" "default" {
  vpc_id									= "${aws_vpc.default.id}"
	cidr_block							= "???"
	map_public_ip_on_launch = true
	
resource "nat_gateway2_subnet" "default" {
  vpc_id									= "${aws_vpc.default.id}"
	cidr_block							= "???"
	map_public_ip_on_launch = true

resource "ec2_hosts_a" "default" {
  vpc_id									= "${aws_vpc.default.id}"
	cidr_block							= "172.31.4.0/24"
	map_public_ip_on_launch = false
	
resource "ec2_hosts_b" "default" {
  vpc_id									= "${aws_vpc.default.id}"
	cidr_block							= "172.31.5.0/24"
	map_public_ip_on_launch = false

resource "aws_instance" "example" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"
}
