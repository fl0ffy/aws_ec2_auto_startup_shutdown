data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  # filter {
  #   name   = "owner-alias"
  #   values = ["amazon"]
  # }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_instance" "test" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  tags = {
    "Name"          = "auto-start-stop-test"
    "Auto-Startup"  = "True"
    "Auto-Shutdown" = "True"
  }
}