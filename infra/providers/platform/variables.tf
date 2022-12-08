variable "aws_region" {}

variable "aws_account" {}

variable "stage" {
  description = "Name of stage. Normally qa, prod"
}


//jenkins
variable "jenkins_controller_port" {
  type    = number
  default = 8080
}

variable "jenkins_jnlp_port" {
  type    = number
  default = 50000
}

variable "jenkins_controller_cpu" {
  type    = number
  default = 2048
}

variable "jenkins_controller_memory" {
  type    = number
  default = 4096
}

variable "jenkins_controller_task_log_retention_days" {
  type    = number
  default = 30
}

variable "jenkins_controller_task_role_arn" {
  type        = string
  description = "An custom task role to use for the jenkins controller (optional)"
  default     = null
}

variable "ecs_execution_role_arn" {
  type        = string
  description = "An custom execution role to use as the ecs exection role (optional)"
  default     = null
}

variable "tags" {
  type        = map(any)
  description = "An object of tag key value pairs"
  default     = {}
}

variable "credentialsParam" {
  default = " "
}

variable "file_system_id" {
  default = " "
}

variable "efs_access_point" {
  default = ""
}

variable "project" {
  default = ""
}

variable "container_image" {
  default = ""
}

variable "kaniko_image" {
  default = ""
}

variable "domain_name" {
  type        = string
  description = "Domain name for ACM certificate"
}

variable "environment" {
  
}

variable "ssl_cert_type" {
  type = string
}

variable "project_short_name" {
  type = string
}

variable "state_bucket_name" {
  description = "Remote backend for terraform state files"
}

//COMMON
variable "aws_role" { }

variable "sns_endpoint_suscriptors" { }

variable "allowed_cidrs" { }