resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
      },
    "Effect": "Allow",
    "Sid": ""
  }]
}
  EOF
}


resource "aws_iam_policy" "lambda_ec2" {
  name        = "lamdba_ec2"
  path        = "/"
  description = "IAM policy for doing EC2 things from lambda"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
  EOF
}


resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "lambda_attach_ec2" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_ec2.arn
}


resource "aws_iam_role_policy_attachment" "lambda_attach_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/files"
  output_path = "${path.module}/myzip/python.zip"
}


# --------------------- StartEC2Instances setup ----------------------
# Create StartEC2Instances lambda function
resource "aws_lambda_function" "StartEC2Instances" {
  filename      = "${path.module}/myzip/python.zip"
  function_name = "StartEC2Instances"
  role          = aws_iam_role.lambda_role.arn
  handler       = "auto-startup.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.policy_attach]
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


# --------------------- StopEC2Instances setup ----------------------
# Create StopEC2Instances lambda function
resource "aws_lambda_function" "StopEC2Instances" {
  filename      = "${path.module}/myzip/python.zip"
  function_name = "StopEC2Instances"
  role          = aws_iam_role.lambda_role.arn
  handler       = "auto-shutdown.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.policy_attach]
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
