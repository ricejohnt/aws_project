resource "aws_lb" "aws_alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http_allowed.id]
  subnets            = [aws_subnet.sub_nat_gateway1b.id, aws_subnet.sub_nat_gateway1c.id]

  enable_deletion_protection = false //false for the sake of convenience, should be true
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.aws_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.jr_hosts.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "jr_hosts" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.jr_vpc.id
  target_type = "ip"

  health_check {
    path = "/"
    port = 80
  }

}
