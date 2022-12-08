locals {
  name_prefix        = "jenkins-${var.project_short_name}"
  route53_alias_name = "jenkins-${var.project_short_name}"
  jenkins_controller_subnet_ids = [
                                    data.aws_ssm_parameter.sb_trust_1.value,
                                    data.aws_ssm_parameter.sb_trust_2.value,
                                    data.aws_ssm_parameter.sb_trust_3.value]
}

## VPC data

data "aws_ssm_parameter" "sb_trust_1" {
  name = "/${var.environment}/network/trust/private_subnet1_id"
}

data "aws_ssm_parameter" "sb_trust_2" {
  name = "/${var.environment}/network/trust/private_subnet2_id"
}

data "aws_ssm_parameter" "sb_trust_3" {
  name = "/${var.environment}/network/trust/private_subnet3_id"
}




data "aws_acm_certificate" "ssl_certificate" {
  domain      = "*.${var.domain_name}"
  types       = ["${var.ssl_cert_type}"]
  most_recent = true
}

data "aws_ssm_parameter" "vpc_main" {
  name = "/${var.environment}/network/main_vpc_id"
}

data "aws_vpc" "vpc_main" {
  id = data.aws_ssm_parameter.vpc_main.value
}

data "aws_ssm_parameter" "efs_access_point_id" {
  name  = "/jenkins/${lower(var.project)}/efs-accessid"
}

data "aws_ssm_parameter" "efs_filesystem_id" {
  name  = "/jenkins/${lower(var.project)}/efs-fsid"
}


data "aws_iam_role" "task_role" {
  name = "${local.name_prefix}-controller-task-role"
}

data "aws_iam_role" "ecs_execution_role" {
  name = "${local.name_prefix}-ecs-execution-role"
}