output "efs_file_system_id" {
  value       = module.serverless_jenkins_common.efs_file_system_id
  description = "The id of the efs file system"
}
output "efs_file_system_dns_name" {
  value       = module.serverless_jenkins_common.efs_file_system_dns_name
  description = "The dns name of the efs file system"
}

output "efs_access_point_id" {
  value       = module.serverless_jenkins_common.efs_access_point_id
  description = "The id of the efs access point"
}

output "efs_security_group_id" {
  value       = module.serverless_jenkins_common.efs_security_group_id
  description = "The id of the efs security group"
}
