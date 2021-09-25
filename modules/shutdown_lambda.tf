# --------------------- StopEC2Instances setup ----------------------
# Create StopEC2Instances lambda function
# figure out how to add a test
resource "aws_lambda_function" "StopEC2Instances" {
  function_name    = "StopEC2Instances"
  role             = var.iam_role_arn
  filename         = data.archive_file.default.output_path
  source_code_hash = data.archive_file.default.output_base64sha256
  handler          = "auto-shutdown.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
}


# Create EventBridge (CloudWatch Events) rule - StopEC2Instances
resource "aws_cloudwatch_event_rule" "StopEC2Instances_events_rule" {
  name                = "StopEC2Instances"
  description         = "Stops EC2 instances every night at 2300 EDT (0300 GMT)."
  schedule_expression = "cron(0 3 * * ? *)"
}


# Tie scheduled event source (event rule) to lambda function
resource "aws_cloudwatch_event_target" "StopEC2Instances_trigger" {
  rule      = aws_cloudwatch_event_rule.StopEC2Instances_events_rule.name
  target_id = "StopEC2Instances"
  arn       = aws_lambda_function.StopEC2Instances.arn
}


# Grant cloudwatch_event_targert permission to invoke lambda function
resource "aws_lambda_permission" "allow_cloudwatch_to_call_StopEC2Instances" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.StopEC2Instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.StopEC2Instances_events_rule.arn
}


resource "aws_cloudwatch_log_group" "StopEC2Instances_log_group" {
  name              = "/aws/lambda/StopEC2Instances"
  retention_in_days = 14
}
