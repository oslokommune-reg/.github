# Provider must be given in each workspace.
# Input: additional providers if used
provider "aws" {
  region = "eu-west-1"
}
terraform {
  required_providers {
    archive = ">= 1.3"
    aws     = "~> 5.62"
    local   = "~> 1.4"
  }
}
