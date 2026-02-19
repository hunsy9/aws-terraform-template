resource "aws_ecs_cluster" "codedeploy_ecs_cluster" {
  name = "codedeploy-ecs-cluster"
}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "codedeploy-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "sample-app"
      image     = "amazon/amazon-ecs-sample"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "codedeploy-ecs-service"
  cluster         = aws_ecs_cluster.codedeploy_ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = aws_subnet.tf_private_subnet[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_blue.arn
    container_name   = "sample-app"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}
