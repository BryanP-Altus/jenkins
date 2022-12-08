data "template_file" "efs_resource_policy" {
  template = file("${path.module}/templates/efs_resource_policy.json.tpl")
  vars = {
  root_user = "arn:aws:iam::${var.account_id}:root"
  resource_name = "arn:aws:elasticfilesystem:${var.region}:${var.account_id}:file-system/${data.aws_efs_file_system.jenkins-efs.id}"
  }
}

// Backup
data "aws_iam_policy_document" "aws_backup_assume_policy" {
  count = var.efs_enable_backup ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

// Jenkins
data "aws_iam_policy_document" "ecs_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "jenkins_controller_task_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:ListContainerInstances"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:RunTask"
    ]
    resources = ["arn:aws:ecs:${var.region}:${var.account_id}:task-definition/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:StopTask",
      "ecs:DescribeTasks"
    ]
    resources = ["arn:aws:ecs:${var.region}:${var.account_id}:task/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:GetParameter",
      "ssm:GetParameters"

    ]
    resources = ["arn:aws:ssm:${var.region}:${var.account_id}:parameter/jenkins*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = ["arn:aws:kms:${var.region}:${var.account_id}:alias/aws/ssm", "arn:aws:kms:${var.region}:${var.account_id}:alias/aws/secretsmanager"]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = ["arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:argus/Dockerhub-xzg6T8"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["arn:aws:iam::${var.account_id}:role/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "elasticfilesystem:ClientMount",
      "ecr:GetAuthorizationToken",
      "ecs:RegisterTaskDefinition",
      "ecs:ListClusters",
      "ecs:DescribeContainerInstances",
      "ecs:ListTaskDefinitions",
      "ecs:DescribeTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess",
    ]
    resources = [
      data.aws_efs_file_system.jenkins-efs.arn,
    ]
  }
}


