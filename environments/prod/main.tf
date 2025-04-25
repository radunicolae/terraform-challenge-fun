terraform {
  backend "s3" {
    bucket       = "radunicolae-s3-state"
    key          = "prod/mars/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

module "infra" {
  source = "../../infra"

  env_name  = var.env_name
  env_owner = var.env_owner
  prod_env  = var.prod_env
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
