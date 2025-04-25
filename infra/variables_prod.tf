variable "lambda_retention_in_days_prod" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  type        = number
  default     = 365
}
