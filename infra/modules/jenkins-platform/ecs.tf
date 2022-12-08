// Jenkins Container Infra (Fargate)
resource "aws_ecs_cluster" "jenkins_controller" {
  name               = "${var.name_prefix}-main"
  tags               = var.tags

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "jenkins_controller" {
  cluster_name = aws_ecs_cluster.jenkins_controller.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_cluster" jenkins_agents {
  name               = "${var.name_prefix}-spot"
  tags               = var.tags
  
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "jenkins_aagents" {
  cluster_name = aws_ecs_cluster.jenkins_agents.name
  capacity_providers = ["FARGATE_SPOT"]
}

data "aws_secretsmanager_secret" "this" {
  name = "argus/Dockerhub"
}

data "aws_ssm_parameter" "datadog_api" {
  name = "/datadog/api_Key"
}

data "aws_security_group" "jenkins_controller_security_group" {
  filter {
    name = "group-name"
    values = ["${var.name_prefix}-controller"]
  }
}

data "template_file" "jenkins_controller_container_def" {
  template = file("${path.module}/templates/jenkins-controller.json.tpl")

  vars = {
    name                    = "${var.name_prefix}-controller"
    jenkins_controller_port = var.jenkins_controller_port
    jnlp_port               = var.jenkins_jnlp_port
    source_volume           = "${var.name_prefix}-efs"
    jenkins_home            = "/var/jenkins_home"
    container_image         = "${var.container_image}"
    region                  = var.region
    account_id              = var.account_id
    project_short_name      = var.project_short_name
    log_group               = aws_cloudwatch_log_group.jenkins_controller_log_group.name
    memory                  = var.jenkins_controller_memory
    cpu                     = var.jenkins_controller_cpu
    credentialsParam        = data.aws_secretsmanager_secret.this.arn
    project                 = var.project
    docker_secret_arn       = var.docker_secret_arn
    security_group          = data.aws_security_group.jenkins_controller_security_group.id
    datadogApiKey           = data.aws_ssm_parameter.datadog_api.value 
  }
}

data "template_file" "jenkins_kaniko_container_def" {
  template = file("${path.module}/templates/jenkins-kaniko.json.tpl")

  vars = {
    name              = "${var.name_prefix}-kaniko"
    container_image   = "${var.kaniko_image}"
    region            = var.region
    account_id        = var.account_id
    log_group         = aws_cloudwatch_log_group.jenkins_controller_log_group.name
    memory            = var.jenkins_controller_memory
    cpu               = var.jenkins_controller_cpu
    credentialsParam  = data.aws_secretsmanager_secret.this.arn
  }
}

resource "aws_cloudwatch_log_group" "jenkins_controller_log_group" {
  name              = var.name_prefix
  retention_in_days = var.jenkins_controller_task_log_retention_days
  tags = var.tags
}

data "aws_efs_file_system" "this" {
  file_system_id = var.file_system_id
}

data "aws_efs_access_point" "this" {
  access_point_id = var.efs_access_point
}


resource "aws_ecs_task_definition" "jenkins_controller" {
  family = var.name_prefix  
  ##Needs Change##
  task_role_arn            = var.jenkins_controller_task_role_arn
  execution_role_arn       = var.ecs_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.jenkins_controller_cpu
  memory                   = var.jenkins_controller_memory
  container_definitions    = data.template_file.jenkins_controller_container_def.rendered

  volume {
    name = "${var.name_prefix}-efs"

    efs_volume_configuration {
      file_system_id = var.file_system_id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = var.efs_access_point
        iam = "ENABLED"
      }
    }
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "jenkins_kaniko" {
  family = var.name_prefix

  task_role_arn            = var.jenkins_controller_task_role_arn
  execution_role_arn       = var.ecs_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.jenkins_controller_cpu
  memory                   = var.jenkins_controller_memory
  container_definitions    = data.template_file.jenkins_kaniko_container_def.rendered
  tags                     = var.tags
}

resource "aws_ecs_service" "jenkins_controller" {
  name = "${var.name_prefix}-controller"

  task_definition        = aws_ecs_task_definition.jenkins_controller.arn
  cluster                = aws_ecs_cluster.jenkins_controller.id
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"
  enable_execute_command = true

  // Assuming we cannot have more than one instance at a time. Ever. 
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0


  service_registries {
    registry_arn = aws_service_discovery_service.controller.arn
    port         = var.jenkins_jnlp_port
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "${var.name_prefix}-controller"
    container_port   = var.jenkins_controller_port
  }

  network_configuration {
    subnets          = var.jenkins_controller_subnet_ids
    security_groups  = [data.aws_security_group.jenkins_controller_security_group.id]
    assign_public_ip = false
  }

  depends_on = [aws_lb_listener.http]
}


resource "aws_service_discovery_private_dns_namespace" "controller" {
  name        = var.name_prefix
  vpc         = var.vpc_id
  description = "Serverless Jenkins discovery managed zone."
}

resource "aws_service_discovery_service" "controller" {
  name = "controller"
  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.controller.id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 10
      type = "A"
    }

    dns_records {
      ttl  = 10
      type = "SRV"
    }
  }
  health_check_custom_config {
    failure_threshold = 5
  }
}
