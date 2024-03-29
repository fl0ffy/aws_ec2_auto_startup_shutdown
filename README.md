
<!-- TABLE OF CONTENTS -->

## About the Project
This project is used to deploy lambda functions and associated components into AWS that automatically shutdown and startup EC2 instances, with the appropriate tags, on a given schedule using EventBridge (CloudWatch Events) as the trigger.

### Use Cases
- Cost savings
- Rebooting causes instance to move backend hardware
- Builds trust in infrastructure

</br>

---
## Required components:
- Git
- Terraform (tested v1.0.7)
- AWS CLI configured with IAM credentials
	- Profiles can be used (see variables)

</br>  

---
## Geting Started

1. Clone the repo to location terraform will be run
	 ```sh
	 git clone https://github.com/your_username_/Project-Name.git
	 ```

1. Change directory into project
	 ```sh
	 cd Project-Name
	 ```

2. Initiate terraform 
	 ```sh
	 terraform init
	 ```

3. Run terrafrom plan
	 ```sh
	 terraform plan
	 ```

4. Run terraform apply to make changes
	 ```sh
	 terraform apply
	 ``` 
	 enter yes when prompted

</br>

---
## Variables

| Variable            | Default Value   | Example Usage                                         |
| :---                | :---:           | :---                                                  |
| aws_config_profile  | default         | terraform apply -var="aws_config_profie=work_profile" |
| aws_region          | us-east-1       | terraform apply -var="aws_region=us-west-2"           |

### Refernce links
[AWS Named Profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)  
[AWS Regions](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html#Concepts.RegionsAndAvailabilityZones.Regions)


</br>

---
## Components deployed:
| Component | TF resource type| resource name |
|---|---|---|
| IAM policy | aws_iam_policy  | lambda_ec2  |
| IAM Role   | aws_iam_role    | lambda_role |
| CloudWatch Event Rule  | aws_cloudwatch_event_rule | StartEC2Instances_event_rule  |
| CloudWatch Event Rule  | aws_cloudwatch_event_rule | StopEC2Instances_event_rule  |
| Lambda Function | aws_lambda_function | StartEC2Instances  |
| Lambda Function | aws_lambda_function | StopEC2Instances  |
| Cloudwatch Log Group | aws_cloudwatch_log_group | StopEC2Instances_log_group |
| Cloudwatch Log Group | aws_cloudwatch_log_group | StartEC2Instances_log_group |
| AWS EC2 Instance (for testing) | aws_instance | test |

</br>

---
## Add Tags to EC2 Instances

The Lambda functions will only act on the specific tags below within the regions in which they are deployed.

The tag `Auto-Startup` set to `True`  will start the ec2 instance at the specified time (default 0600 EDT).

The tag `Auto-Shutdown` set to `True`  will stop the ec2 instance at the specified time (default 2200 EDT).

</br>

---
## About the Scripts in the Lambda Functions

Located in the `files/` directory are two python scripts that are bundled together as a zip archive and given to the lamnbda functions to execute.  Both scripts work similarly by first querying EC2 instance ids using the tag as a filter and then either starting or stopping those returned instances by ID.

</br>

---
## Todo
- [X] Add CloudWatch logging
- [X] Modularize to support multi-region deployments
- [X] Add S3 backend
- [ ] Use dynamic blocks
- [ ] Add a script to add tags to specifed ec2s
- [ ] Variablize:
	- [X] AWS CLI config profile
	- [X] AWS Region
	- [ ] Startup_time (default 2200 EDT)
	- [ ] Shutdown_time (default 0600 EDT)
	- [ ] Startup_tag (default 'Auto-Startup')
	- [ ] Shutdown_tag (default 'Auto-Shutdown')
- [ ] Optional: create script to add tags to all instances

</br>

---
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch ( `git checkout -b feature/AmazingFeature` )
3. Commit your Changes ( `git commit -m 'Add some AmazingFeature'` )
4. Push to the Branch ( `git push origin feature/AmazingFeature` )
5. Open a Pull Request