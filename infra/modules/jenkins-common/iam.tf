resource "aws_efs_file_system_policy" "this" {
  file_system_id = data.aws_efs_file_system.jenkins-efs.id
  policy         = data.template_file.efs_resource_policy.rendered
}

resource "aws_iam_role" "aws_backup_role" {
  count = var.efs_enable_backup ? 1 : 0

  name               = "${var.name_prefix}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.aws_backup_assume_policy[count.index].json
}

resource "aws_iam_role_policy_attachment" "backup_role_policy" {
  count = var.efs_enable_backup ? 1 : 0

  role       = aws_iam_role.aws_backup_role[count.index].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}
resource "aws_iam_role_policy_attachment" "restore_role_policy" {
  count = var.efs_enable_backup ? 1 : 0

  role       = aws_iam_role.aws_backup_role[count.index].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.name_prefix}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}

resource "aws_iam_policy" "ecs_execution_policy" {
  name   = "${var.name_prefix}-ecs-execution-policy"
  policy = data.aws_iam_policy_document.ecs_execution_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
}

resource "aws_iam_policy" "jenkins_controller_task_policy" {
  name   = "${var.name_prefix}-controller-task-policy"
  policy = data.aws_iam_policy_document.jenkins_controller_task_policy.json
}

resource "aws_iam_role" "jenkins_controller_task_role" {
  name               = "${var.name_prefix}-controller-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "jenkins_controller_task" {
  role       = aws_iam_role.jenkins_controller_task_role.name
  policy_arn = aws_iam_policy.jenkins_controller_task_policy.arn
}
