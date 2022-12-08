provider "aws" {
  region     = "eu-west-1"
  default_tags {
    tags = {
      "Organisation"    = "altus-group"
      "Project"         = var.project
      "code-repository" = "serverless-ci"
      "code-pipeline"   = "terraform-cloud"
      "Owner"           = "rahul.dhumal"
      "Environment"     = "qa"

    }
  }
}

locals {
  terraform_organization_id = "AltusGroup"
}

provider "aws" {
  alias  = "cross-region"
  region = "eu-central-1"
}
