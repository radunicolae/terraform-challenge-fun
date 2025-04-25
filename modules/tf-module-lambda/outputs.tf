output "lambda_name" {
  value       = aws_lambda_function.lambda_function.function_name
  description = "Name of the Lambda Function."
}
output "lambda_arn" {
  value       = aws_lambda_function.lambda_function.arn
  description = "ARN of the Lambda Function."
}
