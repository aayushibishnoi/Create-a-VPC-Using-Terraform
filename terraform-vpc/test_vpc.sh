#!/bin/bash

# Test script for Terraform VPC Project

# Check if Terraform is installed
echo "Checking for Terraform..."
if ! command -v terraform >/dev/null 2>&1; then
    echo "FAIL: Terraform not found. Install it with 'sudo apt install terraform'."
    exit 1
fi
echo "PASS: Terraform found"

# Check if AWS CLI is installed
echo "Checking for AWS CLI..."
if ! command -v aws >/dev/null 2>&1; then
    echo "FAIL: AWS CLI not found. Install it with 'sudo apt install awscli'."
    exit 1
fi
echo "PASS: AWS CLI found"

# Run terraform init
echo "Running terraform init..."
terraform init
if [ $? -eq 0 ]; then
    echo "PASS: Terraform initialized"
else
    echo "FAIL: Terraform init failed"
    exit 1
fi

# Run terraform plan
echo "Running terraform plan..."
terraform plan -out=tfplan
if [ $? -eq 0 ]; then
    echo "PASS: Terraform plan created"
else
    echo "FAIL: Terraform plan failed"
    exit 1
fi

# Run terraform apply
echo "Running terraform apply..."
terraform apply -auto-approve tfplan
if [ $? -eq 0 ]; then
    echo "PASS: Terraform apply completed"
else
    echo "FAIL: Terraform apply failed"
    exit 1
fi

# Test 1: Verify VPC exists
echo "Testing VPC existence..."
VPC_ID=$(terraform output -raw vpc_id)
if aws ec2 describe-vpcs --vpc-ids $VPC_ID --region us-east-1 | grep -q "VpcId"; then
    echo "PASS: VPC exists"
else
    echo "FAIL: VPC not found"
fi

# Test 2: Verify public subnet
echo "Testing public subnet..."
PUBLIC_SUBNET_ID=$(terraform output -raw public_subnet_id)
if aws ec2 describe-subnets --subnet-ids $PUBLIC_SUBNET_ID --region us-east-1 | grep -q "SubnetId"; then
    echo "PASS: Public subnet exists"
else
    echo "FAIL: Public subnet not found"
fi

# Test 3: Verify security group
echo "Testing security group..."
SG_ID=$(terraform output -raw security_group_id)
if aws ec2 describe-security-groups --group-ids $SG_ID --region us-east-1 | grep -q "GroupId"; then
    echo "PASS: Security group exists"
else
    echo "FAIL: Security group not found"
fi

# Test 4: Verify internet gateway
echo "Testing internet gateway..."
IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --region us-east-1 | grep -o '"InternetGatewayId": "[^"]*' | cut -d'"' -f4)
if [ -n "$IGW_ID" ]; then
    echo "PASS: Internet gateway exists"
else
    echo "FAIL: Internet gateway not found"
fi

echo "All tests completed!"
# Note: Resources are not destroyed to allow manual verification in AWS Console
# To destroy: terraform destroy -auto-approve
