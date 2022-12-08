// EFS including backups
resource "aws_efs_file_system" "this" {
  count = var.efs_disaster_recovery_id == "" ? 1 : 0

  creation_token = "${var.name_prefix}-fs"

  encrypted                       = var.efs_enable_encryption
  kms_key_id                      = aws_kms_key.efs_kms_key.arn
  performance_mode                = var.efs_performance_mode
  throughput_mode                 = var.efs_throughput_mode
  provisioned_throughput_in_mibps = var.efs_provisioned_throughput_in_mibps
  tags                            = { "Name" : "${var.name_prefix}-efs" }
  dynamic "lifecycle_policy" {
    for_each = var.efs_ia_lifecycle_policy != null ? [var.efs_ia_lifecycle_policy] : []
    content {
      transition_to_ia = lifecycle_policy.value
    }
  }
}

locals {
  efs_id = var.efs_disaster_recovery_id == "" ? aws_efs_file_system.this[0].id : var.efs_disaster_recovery_id
}

data "aws_efs_file_system" "jenkins-efs" {
  file_system_id = local.efs_id
}


resource "aws_kms_key" "efs_kms_key" {
  description = "KMS key used to encrypt Jenkins EFS volume"
}

resource "aws_efs_access_point" "this" {
  file_system_id = data.aws_efs_file_system.jenkins-efs.id
  posix_user {
    gid = 0
    uid = 0
  }
  root_directory {
    path = "/"
    creation_info {
      owner_gid   = var.efs_access_point_uid
      owner_uid   = var.efs_access_point_gid
      permissions = "755"
    }
  }
}


resource "aws_efs_mount_target" "this" {
  for_each = nonsensitive(toset(var.efs_subnet_ids))

  file_system_id  = data.aws_efs_file_system.jenkins-efs.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs_security_group.id]
}


resource "aws_backup_plan" "this" {
  count = var.efs_enable_backup ? 1 : 0

  name = "${var.name_prefix}-plan"
  rule {
    rule_name         = "${var.name_prefix}-backup-rule"
    target_vault_name = aws_backup_vault.this[count.index].name
    schedule          = var.efs_backup_schedule
    start_window      = var.efs_backup_start_window
    completion_window = var.efs_backup_completion_window

    copy_action {
      destination_vault_arn = aws_backup_vault.replica.arn
    }

    dynamic "lifecycle" {
      for_each = var.efs_backup_cold_storage_after_days != null || var.efs_backup_delete_after_days != null ? [true] : []
      content {
        cold_storage_after = var.efs_backup_cold_storage_after_days
        delete_after       = var.efs_backup_delete_after_days
      }
    }
  }

}

resource "aws_backup_vault" "this" {
  count = var.efs_enable_backup ? 1 : 0
  name = "${var.name_prefix}-vault"
}

resource "aws_backup_vault" "replica" {
  provider = aws.cross-region
  name     = "${var.name_prefix}-replica-vault"
}

resource "aws_backup_selection" "this" {
  count = var.efs_enable_backup ? 1 : 0

  name         = "${var.name_prefix}-selection"
  iam_role_arn = aws_iam_role.aws_backup_role[count.index].arn
  plan_id      = aws_backup_plan.this[count.index].id

  resources = [
    data.aws_efs_file_system.jenkins-efs.arn
  ]
}


