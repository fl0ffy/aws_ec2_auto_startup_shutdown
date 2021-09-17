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


resource "aws_iam_role" "lambda_role" {
  name = "iam_role_lambda_function"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
          },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}


