data "aws_availability_zones" "available" {
  state = "available"
}

# resource "aws_autoscaling_group" "ecs_autoscale" {
#   name                 = "ecs_autoscale"
#   launch_configuration = aws_launch_configuration.ecs_launch_cfg.id
#   availability_zones   = data.aws_availability_zones.available.names
#   min_size             = "1"
#   max_size             = "4"
# }

# resource "aws_launch_configuration" "ecs_launch_cfg" {
#   image_id      = "ami-0a887e401f7654935" //Amazon Linux 2 AMI
#   instance_type = "t2.micro"              //Free Tier Eligible
# }
