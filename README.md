# Create a VPC Using Terraform

A project to automate the creation of an AWS VPC using Terraform.

# Project Structure
Create the following directory structure:
    
    terraform-vpc/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── test_vpc.sh
    └── README.md

## Features
- Creates a VPC with a specified CIDR block.
- Sets up public and private subnets.
- Configures security groups, internet gateway, and route tables.
- Tests and verifies VPC deployment.

## Files
- `main.tf`: Terraform configuration for VPC resources.
- `variables.tf`: Variable definitions.
- `outputs.tf`: Output definitions.
- `test_vpc.sh`: Test script for verification.

## Setup
1. Install Terraform: `sudo apt install terraform`.
2. Install AWS CLI: `sudo apt install awscli`.
3. Configure AWS credentials: `aws configure`.
4. Run Terraform: `terraform init`, `terraform plan -out=tfplan`, `terraform apply tfplan`.
5. Run tests: `bash test_vpc.sh`.
6. Verify in AWS Console and destroy: `terraform destroy -auto-approve`.

