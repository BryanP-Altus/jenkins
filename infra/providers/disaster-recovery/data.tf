locals {
  recovery_efs       = var.efs_disaster_recovery_id
  project_short_name = var.project_short_name
}

data "aws_efs_file_system" "recovery" {
  file_system_id = local.recovery_efs
}

data "aws_ssm_parameter" "jenkins_box" {
    name = "/jenkins/sandbox/efs-fsid"
}

data "aws_efs_file_system" "production" {
  file_system_id = data.aws_ssm_parameter.jenkins_box.value
}

data "aws_ssm_parameter" "subnet_trust_aza" {
    name = "/ci/network/trust/private_subnet1_id"
}

data "aws_ssm_parameter" "subnet_trust_azb" {
    name = "/ci/network/trust/private_subnet2_id"
}

data "aws_ssm_parameter" "subnet_trust_azc" {
    name = "/ci/network/trust/private_subnet3_id"
}

data "aws_security_group" "jenkins_controller_security_group" {
  filter {
    name = "group-name"
    values = ["jenkins-${local.project_short_name}-controller"]
  }
}

data "aws_security_group" "jenkins_efs_security_group" {
  filter {
    name = "group-name"
    values = ["jenkins-${local.project_short_name}-efs"]
  }
}

data "aws_subnet" "controller_subnet" {
  id = data.aws_ssm_parameter.subnet_trust_aza.value
}
