output "sqs_queue_arn" {
  value       = aws_sqs_queue.sqs_queue.arn
  description = "ARN of the SQS queue."
}
output "sqs_queue_url" {
  value       = aws_sqs_queue.sqs_queue.url
  description = "URL of the SQS queue."
}
