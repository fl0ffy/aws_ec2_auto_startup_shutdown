variable "aws_config_profile" {
  type    = string
  default = "default"
}


variable "aws_region" {
  type        = string
  description = "This is the region we use in AWS"
  default     = "us-east-1"
}