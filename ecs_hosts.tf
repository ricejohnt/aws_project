data "aws_availability_zones" "available" {
  state = "available"
}

output "url" {
  value = "http://${aws_lb.aws_alb.dns_name}"
}

data "template_file" "nginx_pull" {
  template = file("./template.json.tpl")

  vars = {
    app_image      = "nginx:latest"
    app_port       = "80"
    fargate_cpu    = "256"
    fargate_memory = "512"
    aws_region     = "us-east-1"
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name               = "cluster-hello-world"
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "hello_world" {
  family                   = "hello_world_service"
  container_definitions    = data.template_file.nginx_pull.rendered
  execution_role_arn       = aws_iam_role.ecs_service_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "hello_world" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.hello_world.id
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.jr_hosts.arn
    container_name   = "hello_world"
    container_port   = 80
  }

  network_configuration {
    subnets          = [aws_subnet.ecs_hosts1b.id, aws_subnet.ecs_hosts1c.id]
    security_groups  = [aws_security_group.http_allowed.id]
    assign_public_ip = false
  }

}
