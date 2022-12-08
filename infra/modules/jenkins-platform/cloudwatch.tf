
data "aws_caller_identity" "account" {}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_subscription_filter_jenkins_controller" {
  name            = lower("jenkins_controller-${var.region}-datadog_log_subscription_filter")
  log_group_name  = "/aws/ecs/containerinsights/${aws_ecs_cluster.jenkins_controller.name}/performance"
  role_arn        = "arn:aws:iam::${data.aws_caller_identity.account.account_id}:role/app-datadogkinesis_datadog_firehose_role_cloudwatch"
  destination_arn = "arn:aws:firehose:${var.region}:${data.aws_caller_identity.account.account_id}:deliverystream/DatadogCWLogsforwarder_app-datadog"
  filter_pattern  = ""
}



resource "aws_cloudwatch_log_subscription_filter" "datadog_log_subscription_filter_jenkins_agents" {
  name            = lower("jenkins_agents-${var.region}-datadog_log_subscription_filter")
  log_group_name  = "/aws/ecs/containerinsights/${aws_ecs_cluster.jenkins_agents.name}/performance"
  role_arn        = "arn:aws:iam::${data.aws_caller_identity.account.account_id}:role/app-datadogkinesis_datadog_firehose_role_cloudwatch"
  destination_arn = "arn:aws:firehose:${var.region}:${data.aws_caller_identity.account.account_id}:deliverystream/DatadogCWLogsforwarder_app-datadog"
  filter_pattern  = ""
}