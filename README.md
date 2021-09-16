About
This project is to deploy lambda functions to Automatically shutdown and startup tagged EC2 instances on a given schedule using EventBridge (CloudWatch Events) as the trigger.


Required:
- Terraform
- AWS credentials


Variables:
- region (default us-east-1)
- Startup_time (default 2200 EDT)
- Shutdown_time (default 0600 EDT)
- Startup_tag (default 'Auto-Startup')
- Shutdown_tag (default 'Auto-Shutdown')


Usage
setup script
terraform init
terraform plan
terraform apply
add tags to instances 


todo:
Add a script to add tags to specifed ec2s


Componencts deployed:
- startup lambda function
- shutdown lambda function
- startup IAM role
- shutdown IAM role
- startup eventbridge rule
- shutdown eventbridge rule
- ?
