module "lambda" {
  source = "../modules/tf-module-lambda"

  env_owner = var.env_owner
  env_name  = var.env_name

  event_source_arn   = module.sqs.sqs_queue_arn
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
  sqs_queue_arn      = module.sqs.sqs_queue_arn
  retention_in_days  = var.prod_env ? var.lambda_retention_in_days_prod : var.lambda_retention_in_days
}
module "dynamodb" {
  source = "../modules/tf-module-dynamodb"

  env_owner = var.env_owner
  env_name  = var.env_name
}
module "sqs" {
  source = "../modules/tf-module-sqs"

  env_owner = var.env_owner
  env_name  = var.env_name

  lambda_arn = module.lambda.lambda_arn
}
