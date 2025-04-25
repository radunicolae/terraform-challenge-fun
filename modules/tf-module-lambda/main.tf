locals {
  service_name = "lambda"
  common_tags = {
    Component = "lambda"
    ManagedBy = "Terraform"
    Module    = "tf-module-lambda"
    Owner     = var.env_owner
    Env       = var.env_name
  }
}

## IAM Resources
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "lambda_dynamodb_policy_document" {
  statement {
    sid    = "DynamoDBAccess"
    effect = "Allow"
    resources = [
      var.dynamodb_table_arn
    ]
    actions = [
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DescribeTable",
      "dynamodb:DeleteItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:BatchGetItem"
    ]
  }
}
data "aws_iam_policy_document" "lambda_sqs_policy_document" {
  statement {
    sid    = "SqsAccess"
    effect = "Allow"
    resources = [
      var.sqs_queue_arn
    ]
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage"
    ]
  }
}

resource "aws_iam_role" "lambda_iam_role" {
  name               = "tf-${local.service_name}-${var.env_name}-${var.env_owner}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_cw_policy" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "lambda_xray_policy" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name   = "tf-${local.service_name}-dynamodb-${var.env_name}-${var.env_owner}"
  role   = aws_iam_role.lambda_iam_role.name
  policy = data.aws_iam_policy_document.lambda_dynamodb_policy_document.json
}
resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name   = "tf-${local.service_name}-sqs-${var.env_name}-${var.env_owner}"
  role   = aws_iam_role.lambda_iam_role.name
  policy = data.aws_iam_policy_document.lambda_sqs_policy_document.json
}

## Lambda
resource "aws_lambda_function" "lambda_function" {
  function_name    = "tf-${local.service_name}-${var.env_name}-${var.env_owner}"
  role             = aws_iam_role.lambda_iam_role.arn
  filename         = "hello.zip"
  handler          = "hello.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/hello.zip")

  runtime = "python3.10"
  tracing_config {
    mode = "Active"
  }
  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
      ENV_NAME       = var.env_name
      ENV_OWNER      = var.env_owner
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_event_source_mapping" "lambda_trigger" {
  event_source_arn = var.event_source_arn
  function_name    = aws_lambda_function.lambda_function.arn

  tags = local.common_tags
}

## Cloudwatch
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.retention_in_days

  tags = local.common_tags
}

