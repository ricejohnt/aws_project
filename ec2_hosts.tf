data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_autoscaling_group" "ec2_autoscale" {
  name               = "ec2_autoscale"
  availability_zones = data.aws_availability_zones.available.names
  min_size           = "1"
  max_size           = "4"
  load_balancers     = [aws_lb.aws_alb.id]
  health_check_type  = "ELB"


}
