locals {
  service_name = "dynamodb"
  common_tags = {
    Component = "dynamodb"
    ManagedBy = "Terraform"
    Module    = "tf-module-dynamodb"
    Owner     = var.env_owner
    Env       = var.env_name
  }
}
resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "tf-${local.service_name}-${var.env_name}-${var.env_owner}"
  hash_key     = "ID"
  range_key    = "userId"
  billing_mode = "PAY_PER_REQUEST"

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }
  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  attribute {
    name = "ID"
    type = "S"
  }
  attribute {
    name = "userId"
    type = "S"
  }

  tags = local.common_tags
}
