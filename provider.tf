terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  # backend "s3" {
  #   bucket  = "terraform-states-081726345"
  #   key     = "ec2_auto_startup_shutdown/terraform.tfstate"
  #   region  = "us-east-1"
  #   profile = "playground"
  # }
}


provider "aws" {
  profile = var.aws_config_profile
  region  = "us-east-1"
}


# provider "aws" {
#   alias   = "us-east-2"
#   profile = var.aws_config_profile
#   region  = "us-east-2"
# }