output "lambda_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "iam_policy_lamdba_ec2_function_arn" {
  value = aws_iam_policy.lambda_ec2.arn
}