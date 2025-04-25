## General
variable "env_owner" {
  type        = string
  description = "Environment owner (e.g. team name)"
}
variable "env_name" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}
variable "enable_point_in_time_recovery" {
  type        = bool
  description = "Enable point-in-time recovery for DynamoDB"
  default     = true
}
