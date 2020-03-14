# data "aws_acm_certificate" "server_cert" {
#   domain = "server"
#   types  = ["IMPORTED"]
# }
#
# data "aws_acm_certificate" "root_cert" {
#   domain = "client1.domain.tld"
#   types  = ["IMPORTED"]
# }
#
# resource "aws_ec2_client_vpn_endpoint" "clientvpn" {
#   server_certificate_arn = data.aws_acm_certificate.server_cert.arn
#   client_cidr_block      = "10.1.0.0/16"
#
#   authentication_options {
#     type                       = "certificate-authentication"
#     root_certificate_chain_arn = data.aws_acm_certificate.root_cert.arn
#   }
#
#   connection_log_options {
#     enabled = false
#   }
# }
#
# resource "aws_ec2_client_vpn_network_association" "vpn_sub1b" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.clientvpn.id
#   subnet_id              = aws_subnet.ecs_hosts1b.id
# }
#
# resource "aws_ec2_client_vpn_network_association" "vpn_sub1c" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.clientvpn.id
#   subnet_id              = aws_subnet.ecs_hosts1c.id
# }
