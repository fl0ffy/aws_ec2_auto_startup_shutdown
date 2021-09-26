module "us-east-1" {
  source       = "./modules"
  iam_role_arn = aws_iam_role.iam_for_lambda.arn
  data_path    = data.archive_file.default.output_path
  data_hash    = data.archive_file.default.output_base64sha256
  providers = {
    aws = aws
  }
}

# module "us-east-2" {
#   source = "./modules"
#   iam_role_arn = aws_iam_role.iam_for_lambda.arn
#   data_path = data.archive_file.default.output_path
#   data_hash = data.archive_file.default.output_base64sha256
#   providers = {
#     aws = aws.us-east-2
#   }
# }