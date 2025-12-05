#!/bin/bash
set -e

echo "Initializing Terraform..."
terraform -chdir=../terraform init

echo "Applying Terraform configuration..."
terraform -chdir=../terraform apply -auto-approve

ALB_DNS=$(terraform -chdir=../terraform output -raw alb_dns)
echo "Deployment complete!"
echo "Your API is available at: http://$ALB_DNS"
