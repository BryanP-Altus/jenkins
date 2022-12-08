terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# CICD Account w/ Assume Role in NOC Account
provider "aws" {
  region = "eu-west-1"
}