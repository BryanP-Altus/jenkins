variable "state_bucket_name" { description = "Remote backend for terraform state files" }

variable "artifacts_bucket_name" { description = "Terraform plan/artifacts will be stored in this bucket" }

variable "organisation" { description = "To identify the organisation" }

variable "component" { description = "To identify the project to which this resource belongs to, for e.g. Optimiser, Foundry, Engine, Portfolio etc." }

variable "business_owner" { description = "Name of the person - To easily identify who is the business person responsible for the service/resource." }

variable "aws_account" { description = "This will be used to create resources & usually this account number will be prefixed to resource names to keep them unique especially S3 buckets" }

variable "aws_region" { description = "The region in which all requested AWS resources will be created.If you wish to change,then pass it in var-file" }

variable "created_by" { description = "Someone from devops who has created this stack or own this stack. Can have comma separated multiple names" }
