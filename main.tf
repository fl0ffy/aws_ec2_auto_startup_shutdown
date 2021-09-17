terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
      }
    }
}

provider "aws" {
  region = "us-east-1"
}

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

# Create a lambda function
resource "aws_lambda_function" "StopEC2Instances" {
  filename      = "${path.module}/myzip/python.zip"
  function_name = "My_Lambda_Function"
  role          = aws_iam_role.lambda_role.arn 
  handler       = "auto-shutdown.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.policy_attach]
}