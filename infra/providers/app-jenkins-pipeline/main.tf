data "aws_ssm_parameter" "build_role_arn" {
  name = "/ci/app/pipeline/build-role-arn"
}

data "aws_ssm_parameter" "pipeline_role_arn" {
  name = "/ci/app/pipeline/pipeline-role-arn"
}

data "aws_ssm_parameter" "github_connection_arn" {
  name = "/ci/shared/app/github_connection"
}

module "s3" {
  source          = "git::https://github.com/AltusPerformancePlatform/terraform-aws-s3-bucket.git?ref=v0.5.0"
  enterprise_name = var.aws_account
  custom_policy   = local.custom_policy
  environment     = local.environment
  app_teamname    = "jenkins"
  buckets_purpose = { "artifact" : { "logging_enabled" : "false", "replication_enabled" : "false", "custom_policy_enabled" : "false" } }
  region          = "eu-west-1"
  tags = { "Project" : "App",
    "Scope" : "Jenkins",
  }
}

module "codepipeline_jenkins_devops" {
  for_each                 = module.s3.bucket_id
  source                   = "git::https://github.com/AltusPerformancePlatform/terraform-aws-codepipeline.git?ref=v1.1.0"
  environment              = local.environment
  name                     = "jenkins-devops"
  pipeline_role_arn        = data.aws_ssm_parameter.pipeline_role_arn.value
  component                = local.component
  action                   = "build"
  automatic_trigger        = false
  scope                    = local.scope
  business_owner           = local.business_owner
  submodule                = local.submodule
  artifacts_s3_bucket_name = module.s3.bucket_id["artifact"]
  artifacts_type           = "S3"
  github_organization      = "AltusPerformancePlatform"
  repository_name          = "serverless-ci"
  repository_branch_name   = "main"
  github_connection_arn    = data.aws_ssm_parameter.github_connection_arn.value
  stages                   = local.pipeline_stages_devops

  depends_on = [
    module.s3
  ]
}

module "codepipeline_jenkins_platform" {
  for_each                 = module.s3.bucket_id
  source                   = "git::https://github.com/AltusPerformancePlatform/terraform-aws-codepipeline.git?ref=v1.1.0"
  environment              = local.environment
  name                     = "jenkins-platform"
  pipeline_role_arn        = data.aws_ssm_parameter.pipeline_role_arn.value
  component                = local.component
  action                   = "build"
  automatic_trigger        = false
  scope                    = local.scope
  business_owner           = local.business_owner
  submodule                = local.submodule
  artifacts_s3_bucket_name = module.s3.bucket_id["artifact"]
  artifacts_type           = "S3"
  github_organization      = "AltusPerformancePlatform"
  repository_name          = "serverless-ci"
  repository_branch_name   = "main"
  github_connection_arn    = data.aws_ssm_parameter.github_connection_arn.value
  stages                   = local.pipeline_stages_platform

  depends_on = [
    module.s3
  ]
}

module "codepipeline_jenkins_so" {
  for_each                 = module.s3.bucket_id
  source                   = "git::https://github.com/AltusPerformancePlatform/terraform-aws-codepipeline.git?ref=v1.1.0"
  environment              = local.environment
  name                     = "jenkins-so"
  pipeline_role_arn        = data.aws_ssm_parameter.pipeline_role_arn.value
  component                = local.component
  action                   = "build"
  automatic_trigger        = false
  scope                    = local.scope
  business_owner           = local.business_owner
  submodule                = local.submodule
  artifacts_s3_bucket_name = module.s3.bucket_id["artifact"]
  artifacts_type           = "S3"
  github_organization      = "AltusPerformancePlatform"
  repository_name          = "serverless-ci"
  repository_branch_name   = "main"
  github_connection_arn    = data.aws_ssm_parameter.github_connection_arn.value
  stages                   = local.pipeline_stages_so

  depends_on = [
    module.s3
  ]
}

module "codepipeline_jenkins_sandbox" {
  for_each                 = module.s3.bucket_id
  source                   = "git::https://github.com/AltusPerformancePlatform/terraform-aws-codepipeline.git?ref=v1.1.0"
  environment              = local.environment
  name                     = "jenkins-sandbox"
  pipeline_role_arn        = data.aws_ssm_parameter.pipeline_role_arn.value
  component                = local.component
  action                   = "build"
  automatic_trigger        = false
  scope                    = local.scope
  business_owner           = local.business_owner
  submodule                = local.submodule
  artifacts_s3_bucket_name = module.s3.bucket_id["artifact"]
  artifacts_type           = "S3"
  github_organization      = "AltusPerformancePlatform"
  repository_name          = "serverless-ci"
  repository_branch_name   = "main"
  github_connection_arn    = data.aws_ssm_parameter.github_connection_arn.value
  stages                   = local.pipeline_stages_sandbox

  depends_on = [
    module.s3
  ]
}

module "codepipeline_jenkins_genesis" {
  for_each                 = module.s3.bucket_id
  source                   = "git::https://github.com/AltusPerformancePlatform/terraform-aws-codepipeline.git?ref=v1.1.0"
  environment              = local.environment
  name                     = "jenkins-genesis"
  pipeline_role_arn        = data.aws_ssm_parameter.pipeline_role_arn.value
  component                = local.component
  action                   = "build"
  automatic_trigger        = false
  scope                    = local.scope
  business_owner           = local.business_owner
  submodule                = local.submodule
  artifacts_s3_bucket_name = module.s3.bucket_id["artifact"]
  artifacts_type           = "S3"
  github_organization      = "AltusPerformancePlatform"
  repository_name          = "serverless-ci"
  repository_branch_name   = "main"
  github_connection_arn    = data.aws_ssm_parameter.github_connection_arn.value
  stages                   = local.pipeline_stages_devops

  depends_on = [
    module.s3
  ]
}
