resource "aws_iam_role" "lambda_role" {
  name = "lambda-Role-recovery"

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

  managed_policy_arns = [ "arn:aws:iam::aws:policy/AmazonEC2FullAccess" ]
}

data "template_file" "recovery_function" {    
	template = "${file("${path.module}/templates/recovery.py.tpl")}"
	vars = {
		efs_id        = "${local.recovery_efs}"
		controller_sg = "${data.aws_security_group.jenkins_controller_security_group.id}"
		project       = "${local.project_short_name}"
		vpc           = ""
		subnet        = "${data.aws_subnet.controller_subnet.id}"
	}
}

resource "local_file" "rendered_template" {
    content     = "${data.template_file.recovery_function.rendered}"
    filename 	= "${path.module}/rendered/recovery_function.py"
}

data "archive_file" "lambda_recovery_zip" {
  type = "zip"
  output_path = "${path.module}/recovery_function.zip"
  source_dir = "${path.module}/rendered/"
  depends_on = [local_file.rendered_template]
}

resource "aws_lambda_function" "recovery_lambda_function" {
        function_name    = "lambdaRecovery"
        filename         = "${path.module}/recovery_function.zip"
        source_code_hash = data.archive_file.lambda_recovery_zip.output_base64sha256
        role             = aws_iam_role.lambda_role.arn
        runtime          = "python3.9"
        handler          = "recovery_function.lambda_handler"
        timeout          = 10
}

resource "aws_lambda_invocation" "example" {
  function_name = aws_lambda_function.recovery_lambda_function.function_name

  input = jsonencode({
    key1 = "Recovery"
  })
}

output "result_entry" {
  value = jsondecode(aws_lambda_invocation.example.result)
}