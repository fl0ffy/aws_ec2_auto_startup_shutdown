output "lambda_role_name" {
  value = aws_iam_role.iam_for_lambda.name
}

output "lambda_role_arn" {
  value = aws_iam_role.iam_for_lambda.arn
}

output "iam_policy_lamdba_ec2_function_arn" {
  value = aws_iam_policy.lambda_ec2.arn
}