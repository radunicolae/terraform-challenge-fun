module "lambda-service" {
  source = "../modules/tf-module-lambda"

  env_owner = var.env_owner
  env_name  = var.env_name

  event_source_arn   = module.sqs-service.sqs_queue_arn
  dynamodb_table_arn = module.dynamodb-service.dynamodb_table_arn
  sqs_queue_arn      = module.sqs-service.sqs_queue_arn
  retention_in_days  = var.prod_env ? var.lambda_retention_in_days_prod : var.lambda_retention_in_days
}
module "dynamodb-service" {
  source = "../modules/tf-module-dynamodb"

  env_owner = var.env_owner
  env_name  = var.env_name
}
module "sqs-service" {
  source = "../modules/tf-module-sqs"

  env_owner = var.env_owner
  env_name  = var.env_name

  lambda_arn = module.lambda-service.lambda_arn
}
