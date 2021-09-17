# Creating IAM role so that Lambda service to assume the role and access other AWS services. 
resource "aws_iam_role" "lambda_role" {
  name = "iam_role_lambda_function"
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


# IAM policy for starting ec2
resource "aws_iam_policy" "lambda_ec2" {
  name = "iam_policy_lamdba_ec2_function"
  path = "/"
  description = "IAM policy for doing EC2 things from lambda"
  policy = <<EOF
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


# Policy Attachment on the role
resource "aws_iam_role_policy_attachment" "policy_attach" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_ec2.arn
}


# Generates an archive from content, a file, or a directory of files.
data "archive_file" "default" {
  type  = "zip"
  source_dir = "${path.module}/files"
  output_path = "${path.module}/myzip/python.zip"
}


# Create StartEC2Instances lambda function
resource "aws_lambda_function" "StartEC2Instances" {
  filename      = "${path.module}/myzip/python.zip"
  function_name = "StartEC2Instances"
  role          = aws_iam_role.lambda_role.arn 
  handler       = "auto-startup.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.policy_attach]
}


# Create StopEC2Instances lambda function
resource "aws_lambda_function" "StopEC2Instances" {
  filename      = "${path.module}/myzip/python.zip"
  function_name = "StopEC2Instances"
  role          = aws_iam_role.lambda_role.arn 
  handler       = "auto-shutdown.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.policy_attach]
}


# Create EventBridge (CloudWatch Events) rule - StartEC2Instances
resource "aws_cloudwatch_event_rule" "StartEC2Instances_events_rule" {
    name = "StartEC2Instances"
    description = "Starts EC2 instances every Morning at 0600 EDT (1000 GMT)."
    schedule_expression = "cron(0 10 * * ? *)"
}


# Create EventBridge (CloudWatch Events) rule - StopEC2Instances
resource "aws_cloudwatch_event_rule" "StopEC2Instances_events_rule" {
    name = "StopEC2Instances"
    description = "Stops EC2 instances every night at 2300 EDT (0300 GMT)."
    schedule_expression = "cron(0 3 * * ? *)"
}


resource "aws_cloudwatch_event_target" "StartEC2Instances_trigger" {
    rule = "${aws_cloudwatch_event_rule.StartEC2Instances_events_rule.name}"
    target_id = "StartEC2Instances"
    arn = "${aws_lambda_function.StartEC2Instances.arn}"
}


resource "aws_cloudwatch_event_target" "StopEC2Instances_trigger" {
    rule = "${aws_cloudwatch_event_rule.StopEC2Instances_events_rule.name}"
    target_id = "StopEC2Instances"
    arn = "${aws_lambda_function.StopEC2Instances.arn}"
}


resource "aws_lambda_permission" "allow_cloudwatch_to_call_StartEC2Instances" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.StartEC2Instances.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.StartEC2Instances_events_rule.arn}"
}


resource "aws_lambda_permission" "allow_cloudwatch_to_call_StopEC2Instances" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.StopEC2Instances.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.StopEC2Instances_events_rule.arn}"
}