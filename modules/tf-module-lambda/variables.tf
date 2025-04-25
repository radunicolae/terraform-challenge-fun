## General
variable "env_owner" {
  type        = string
  description = "Environment owner (e.g. team name)"
}
variable "env_name" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}
variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  type        = number
  default     = 30
}
variable "event_source_arn" {
  description = "The event source ARN - this is required for Kinesis stream, DynamoDB stream, SQS queue, MQ broker, MSK cluster or DocumentDB change stream."
  type        = string
}
variable "dynamodb_table_arn" {
  description = "Dynamodb table where you want your lambda to write data"
  type        = string
}
variable "sqs_queue_arn" {
  description = "ARN of the SQS queue."
  type        = string
}
