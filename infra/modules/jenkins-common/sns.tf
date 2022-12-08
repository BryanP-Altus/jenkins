data "aws_kms_alias" "sns_key" {
  name = "alias/aws/sns"
}

module "sns_notifications" {
    source = "git::https://github.com/AltusPerformancePlatform/terraform-aws-sns.git?ref=v0.1.2"

  account_name            = var.environment
  functional_area         = "jenkins"
  scope                   = var.project
  component_name          = "sns"
  topic_name              = "jenkins-${var.project}"
  topic_subscription_type = "email"
  kms_master_key_id       = data.aws_kms_alias.sns_key.target_key_id
  tags                    = var.tags
  endpoint_suscriptors    = var.sns_endpoint_suscriptors
}