
<!-- TABLE OF CONTENTS -->

## About the Project
This project is to deploy lambda functions to Automatically shutdown and startup tagged EC2 instances on a given schedule using EventBridge (CloudWatch Events) as the trigger.

---
### Required components:
- git
- Terraform (tested v1.0.7)
- AWS IAM credentials

---
### Geting Started

1. Clone the repo to location terraform will be run
   ```sh
   git clone https://github.com/your_username_/Project-Name.git
   ```

1. Change directory into project
   ```sh
   cd project
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

---
### todo:
- Add a script to add tags to specifed ec2s
- add cloudwatch logging
- setup script
  - specify credentials
- Pull out and variablize:
  - list of regions (default ["us-east-1"])
  - Startup_time (default 2200 EDT)
  - Shutdown_time (default 0600 EDT)
  - Startup_tag (default 'Auto-Startup')
  - Shutdown_tag (default 'Auto-Shutdown')
  - Optional: create script to add tags to all instances

---
### Components deployed:
- startup lambda function
- shutdown lambda function
- startup IAM role
- shutdown IAM role
- startup eventbridge rule
- shutdown eventbridge rule
- ?

---
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request