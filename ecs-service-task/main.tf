data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Default VPC"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

resource "aws_security_group" "allow_sg" {
  name        = "tsanghan_allow_tls"
  description = "Allow traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #cidr_blocks = [data.aws_vpc.selected.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tsanghan-ce6"
  }
}

data "aws_ecs_cluster" "tsanghan-ce6" {
  cluster_name = "tsanghan-ce6-ecs-cluster"
}

resource "aws_ecs_task_definition" "tsanghan-ce6" {
  family                   = "tsanghan-ce6"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name  = "python-app"
      image = var.container_image

      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
        #   hostPort      = 8080
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "tsanghan-ce6" {
  name            = "tsanghan-ce6"
  cluster         = data.aws_ecs_cluster.tsanghan-ce6.id
  task_definition = aws_ecs_task_definition.tsanghan-ce6.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnets.public.ids
    security_groups  = [aws_security_group.allow_sg.id]
    assign_public_ip = true
  }
  #   iam_role        = aws_iam_role.foo.arn
  #   depends_on      = [aws_iam_role_policy.foo]

  #   ordered_placement_strategy {
  #     type  = "binpack"
  #     field = "cpu"
  #   }

  #   load_balancer {
  #     target_group_arn = aws_lb_target_group.foo.arn
  #     container_name   = "mongo"
  #     container_port   = 8080
  #   }

  #   placement_constraints {
  #     type       = "memberOf"
  #     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  #   }
}