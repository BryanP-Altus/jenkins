provider "aws" {
  region     = "eu-west-1"
  default_tags {
    tags = {
      "Organisation"    = "altus-group"
      "Project"         = var.project
      "code-repository" = "AltusPerformancePlatform/serverless-ci"
      "Owner"           = "rahul.dhumal"
      "Environment"     = "cicd"
    }
  }
}

locals {
  terraform_organization_id = "altusgroup"
}
