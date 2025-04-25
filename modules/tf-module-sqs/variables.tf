## General
variable "env_owner" {
  type        = string
  description = "Environment owner (e.g. team name)"
}
variable "env_name" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}
variable "lambda_arn" {
  description = "ARN of the Lambda Function."
  type        = string
}
