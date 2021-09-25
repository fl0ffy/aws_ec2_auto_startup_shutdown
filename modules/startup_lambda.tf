# --------------------- StartEC2Instances setup ----------------------
# figure out how to add a test
resource "aws_lambda_function" "StartEC2Instances" {
  function_name    = "StartEC2Instances"
  role             = var.iam_role_arn
  filename         = data.archive_file.default.output_path
  source_code_hash = data.archive_file.default.output_base64sha256
  handler          = "auto-startup.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
}

# Create EventBridge (CloudWatch Events) rule - StartEC2Instances
resource "aws_cloudwatch_event_rule" "StartEC2Instances_events_rule" {
  name                = "StartEC2Instances"
  description         = "Starts EC2 instances every Morning at 0600 EDT (1000 GMT)."
  schedule_expression = "cron(0 10 * * ? *)"
}


# Tie scheduled event source (event rule) to lambda function
resource "aws_cloudwatch_event_target" "StartEC2Instances_trigger" {
  rule      = aws_cloudwatch_event_rule.StartEC2Instances_events_rule.name
  target_id = "StartEC2Instances"
  arn       = aws_lambda_function.StartEC2Instances.arn
}


# Grant cloudwatch_event_targert permission to invoke lambda function
resource "aws_lambda_permission" "allow_cloudwatch_to_call_StartEC2Instances" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.StartEC2Instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.StartEC2Instances_events_rule.arn
}


resource "aws_cloudwatch_log_group" "StartEC2Instances_log_group" {
  name              = "/aws/lambda/StartEC2Instances"
  retention_in_days = 14
}
