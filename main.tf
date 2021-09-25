module "us-east-1" {
  source = "./modules"
  
  iam_role_arn = aws_iam_role.iam_for_lambda.arn


  providers = {
    aws = aws
   }
}

module "us-east-2" {
  source = "./modules"

  iam_role_arn = aws_iam_role.iam_for_lambda.arn

  providers = {
    aws = aws.us-east-2
   }
}