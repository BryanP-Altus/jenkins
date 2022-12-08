locals {
  name_prefix                   = "jenkins-${var.project_short_name}"
  route53_alias_name            = "jenkins-${var.project_short_name}"
  efs_subnet_ids                = [
                                    "${data.aws_ssm_parameter.sb_res_1.value}", 
                                    "${data.aws_ssm_parameter.sb_res_2.value}",
                                    "${data.aws_ssm_parameter.sb_res_3.value}"
                                  ]
  alb_subnet_ids                = [
                                    data.aws_ssm_parameter.sb_tgw_1.value,
                                    data.aws_ssm_parameter.sb_tgw_2.value,
                                    data.aws_ssm_parameter.sb_tgw_3.value
                                  ]
}


data "aws_route53_zone" "selected" {
  name         = var.domain_name
} 

data "aws_acm_certificate" "ssl_certificate" {
  domain      = "*.${var.domain_name}"
  types       = ["${var.ssl_cert_type}"]
  most_recent = true
}

# VPC data

data "aws_ssm_parameter" "vpc_main" {
  name = "/${var.environment}/network/main_vpc_id"
}

data "aws_vpc" "vpc_main" {
  id = data.aws_ssm_parameter.vpc_main.value
}

data "aws_ssm_parameter" "sb_tgw_1" {
  name = "/${var.environment}/network/tgw/private_subnet1_id"
}

data "aws_ssm_parameter" "sb_tgw_2" {
  name = "/${var.environment}/network/tgw/private_subnet2_id"
}

data "aws_ssm_parameter" "sb_tgw_3" {
  name = "/${var.environment}/network/tgw/private_subnet3_id"
}

data "aws_ssm_parameter" "sb_res_1" {
  name = "/${var.environment}/network/res/private_subnet1_id"
}

data "aws_ssm_parameter" "sb_res_2" {
  name = "/${var.environment}/network/res/private_subnet2_id"
}

data "aws_ssm_parameter" "sb_res_3" {
  name = "/${var.environment}/network/res/private_subnet3_id"
}
