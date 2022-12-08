module "serverless_jenkins_common" {
  source                        = "../../modules/jenkins-common"
  region                        = var.region
  stage                         = var.stage
  hosted_zone                   = var.domain_name
  domain_name                   = "*.${var.domain_name}"
  name_prefix                   = local.name_prefix
  tags                          = var.tags
  vpc_id                        = data.aws_vpc.vpc_main.id
  efs_subnet_ids                = local.efs_subnet_ids
  jenkins_controller_subnet_ids = var.jenkins_controller_subnet_ids
  alb_subnet_ids                = local.alb_subnet_ids
  alb_acm_certificate_arn       = data.aws_acm_certificate.ssl_certificate.arn
  route53_alias_name            = local.route53_alias_name
  route53_zone_id               = data.aws_route53_zone.selected.zone_id
  account_id                    = var.aws_account
  project                       = var.project
  route53_create_alias          = true
  allowed_cidrs                 = var.allowed_cidrs
  sns_endpoint_suscriptors      = var.sns_endpoint_suscriptors
  environment                   = var.environment
  efs_disaster_recovery_id      = var.efs_disaster_recovery_id
}

resource "aws_ssm_parameter" "efs-accessid-as-parameter" {
  name  = "/jenkins/${lower(var.project)}/efs-accessid"
  type  = "String"
  value = module.serverless_jenkins_common.efs_access_point_id
  overwrite = true
  description = "EFS access id for the given jenkins.(This is managed via terraform. Please do not update manually)"
  tags = {
    Name= "/jenkins/${lower(var.project)}/efs-id"
    Project = var.project
  }
}

resource "aws_ssm_parameter" "efs-fsid-as-parameter" {
  name  = "/jenkins/${lower(var.project)}/efs-fsid"
  type  = "String"
  value = module.serverless_jenkins_common.efs_file_system_id
  overwrite = true
  description = "EFS File system Id for the given jenkins.(This is managed via terraform. Please do not update manually)"
  tags = {
    Name= "/jenkins/${lower(var.project)}/efs-id"
    Project = var.project
  }
}
