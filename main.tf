resource "aws_ecs_cluster" "cluster" {
  name = "cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


resource "aws_ecs_task_definition" "hello-world-nodejs-task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  container_definitions    = jsonencode([
    {
      name: "hello-world-nodejs",
      image: "pvermeyden/nodejs-hello-world:a1e8cf1edcc04e6d905078aed9861807f6da0da4",
      cpu: 512,
      memory: 2048,
      essential: true,
      portMappings: [
        {
          containerPort: 80,
          hostPort: 80,
        },
      ],
    },
  ])

  tags = {
    Application = "Hello world nodejs application"
  }
}

resource "aws_ecs_service" "hello-world-nodejs-service" {
  name            = "hello-world-nodejs-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.hello-world-nodejs-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tf-poc.arn
    container_name   = "hello-world-nodejs"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http_forward]

  tags = {
    Application = "Hello world node js app"
  }
}

resource "aws_cloudwatch_log_group" "hello-world-nodejs-log" {
  name = "hello-world-nodejs-log"

  tags = {
    Application = "Hello world node js app"
  }
}