
variable "region" {}
variable "account_id" {}

variable "stage" {
  description = "Name of stage. Normally qa, prod"
}

variable "jenkins_ecr_repository_name" {
  type        = string
  default     = "serverless-jenkins-controller"
  description = "Name for Jenkins controller ECR repository"
}

variable "jenkins_ecr_repository_kaniko_name" {
  type        = string
  default     = "serverless-jenkins-spot-kaniko"
  description = "Name for Jenkins spot-kaniko ECR repository"
}

variable "name_prefix" {
  type    = string
  default = "serverless-jenkins"
}

variable "vpc_id" {
  type = string
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

variable "jenkins_controller_subnet_ids" {
  type        = list(string)
  description = "A list of subnets for the jenkins controller fargate service (required)"
  default     = null
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
variable container_image { }

variable kaniko_image { }

variable "alb_acm_certificate_arn" {
  type        = string
  description = "The ACM certificate ARN to use for the alb"
}

variable "project_short_name" {
  type = string
}

variable "docker_secret_arn" {
  type    = string
  default = "arn:aws:secretsmanager:eu-west-1:574041070244:secret:argus/Dockerhub-xzg6T8"
}