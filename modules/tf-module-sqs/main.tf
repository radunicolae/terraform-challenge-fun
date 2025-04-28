locals {
  service_name = "sqs"
  common_tags = {
    Component = "sqs"
    ManagedBy = "Terraform"
    Module    = "tf-module-sqs"
    Owner     = var.env_owner
    Env       = var.env_name
  }
}

## IAM Resources
data "aws_iam_policy_document" "sqs_queue_policy_document" {
  statement {
    sid    = "SQSPerms"
    effect = "Allow"
    actions = [
      "sqs:SetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes",
      "sqs:DeleteMessage"
    ]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [var.lambda_arn]
    }
    resources = [aws_sqs_queue.sqs_queue.arn]
  }
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = data.aws_iam_policy_document.sqs_queue_policy_document.json
}

## SQS queue
resource "aws_sqs_queue" "sqs_queue" {
  name                       = "tf-${local.service_name}-${var.env_name}-${var.env_owner}"
  sqs_managed_sse_enabled    = true
  message_retention_seconds  = 259200 # 3 days
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 60
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_dlq_queue.arn
    maxReceiveCount     = 10
  })

  tags = local.common_tags
}

resource "aws_sqs_queue" "sqs_dlq_queue" {
  name                      = "tf-${local.service_name}-${var.env_name}-${var.env_owner}-dlq"
  sqs_managed_sse_enabled   = true
  message_retention_seconds = 1209600 # 14 days
  receive_wait_time_seconds = 20

  tags = local.common_tags
}

resource "aws_sqs_queue_redrive_allow_policy" "terraform_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.sqs_dlq_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.sqs_queue.arn]
  })
}
