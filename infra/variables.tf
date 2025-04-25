## General
variable "env_owner" {
  type        = string
  description = "Environment owner (e.g. team name)"
}
variable "env_name" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}
variable "prod_env" {
  description = "Specify if the env is prod or not"
  type        = bool
}
variable "lambda_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  type        = number
  default     = 30
}
