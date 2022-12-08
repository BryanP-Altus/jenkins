data "aws_ssm_parameter" "jenkins_sns" {
    name="/ci/jenkins/${var.project}/sns"
}

locals {
  monitoring_tags = {
    Project   = "App"
    Scope     = "Alerts"
    Module    = "Jenkins"
    Submodule = var.project
    Env       = "ci"
    CreatedBy = "Thoughtworks"
    Owner     = "Brian DelPizzo"
  }
}


resource "aws_iam_role" "lambda_alerts_role" {
  name = "lambda-sns-${var.project_short_name}-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
EOF

inline_policy {
    name = "alert_sns_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["sns:Publish"]
          Effect   = "Allow"
          Resource = "${data.aws_ssm_parameter.jenkins_sns.value}"
        },
      ]
    })
  }
}

data "template_file" "alert_function" {    
	template = "${file("${path.module}/templates/alerts.py.tpl")}"
	vars = {
		sns_topic = "${data.aws_ssm_parameter.jenkins_sns.value}"
	}
}

resource "local_file" "rendered_template" {
    content     = "${data.template_file.alert_function.rendered}"
    filename 	= "${path.module}/rendered/alert_function.py"
}

data "archive_file" "lambda_alert_zip" {
  type = "zip"
  output_path = "${path.module}/rendered/alert_function.zip"
  source_dir = "${path.module}/rendered/"
  depends_on = [local_file.rendered_template]
}

resource "aws_lambda_function" "lambda_alert_function" {
        function_name    = "jenkins-${var.project_short_name}-alert"
        filename         = "${path.module}/rendered/alert_function.zip"
        source_code_hash = data.archive_file.lambda_alert_zip.output_base64sha256
        role             = aws_iam_role.lambda_alerts_role.arn
        runtime          = "python3.9"
        handler          = "alert_function.lambda_handler"
        timeout          = 10
}


resource "aws_cloudwatch_event_rule" "jenkins_monitor" {
  name          = "jenkins-${var.project_short_name}-monitor"
  event_pattern = "{\"detail\":{\"clusterArn\":[\"arn:aws:ecs:eu-west-1:574041070244:cluster/jenkins-${var.project_short_name}-main\"]},\"detail-type\":[\"ECS Task State Change\",\"ECS Container Instance State Change\",\"ECS Service Action\"],\"source\":[\"aws.ecs\"]}"
  tags          = local.monitoring_tags
}

resource "aws_cloudwatch_event_target" "jenkins_alert" {
  target_id = "jenkins-${var.project_short_name}-alerts"
  arn       = aws_lambda_function.lambda_alert_function.arn 
  rule      = aws_cloudwatch_event_rule.jenkins_monitor.name
}

resource "aws_lambda_permission" "jenkins_alert" {
  statement_id  = "JenkinsAlert"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_alert_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.jenkins_monitor.arn
}
