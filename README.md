# Terraform AWS Infrastructure Deployment

This repository contains Terraform scripts to provision AWS infrastructure including:

- VPC, subnets, NAT Gateway
- EC2 instances
- Application Load Balancer (ALB)
- IAM roles and policies
- CloudWatch Log Groups

---

## Deployment Steps

1. **Clone the repository:**

git clone https://github.com/Rohitkumar44/infra_devops-clean
cd infra_devops-clean/terraform

Initialize Terraform:

terraform init



Plan the deployment (optional, recommended):

terraform plan


Apply the Terraform configuration:

terraform apply -auto-approve


Verify ALB DNS output:

terraform output alb_dns



Testing Steps

Navigate to the scripts folder:

cd ../scripts


Run the test script:

./test.sh



Expected output:

ALB DNS printed

Response from / endpoint

Response from /health endpoint



Teardown Steps

Navigate to Terraform folder:

cd ../terraform

Destroy the infrastructure:

terraform destroy -auto-approve


Confirm deletion in AWS Console:

Check VPCs, EC2 instances, ALB, Target Groups, IAM Roles, and CloudWatch Log Groups.



GitHub Actions Workflow (Optional)

You can automate Terraform deployments using GitHub Actions:

name: Terraform Deploy / Destroy

on:
  workflow_dispatch:   # Manual trigger from GitHub Actions

jobs:
  deploy:
    name: Deploy Infrastructure
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.7

      - name: Terraform Init
        working-directory: ./terraform
        run: terraform init

      - name: Terraform Apply
        working-directory: ./terraform
        run: terraform apply -auto-approve
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.AWS_REGION }}

  destroy:
    name: Destroy Infrastructure
    runs-on: ubuntu-latest
    if: github.event_name == 'workflow_dispatch' # Only manual trigger
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.7

      - name: Terraform Init
        working-directory: ./terraform
        run: terraform init

      - name: Terraform Destroy
        working-directory: ./terraform
        run: terraform destroy -auto-approve
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.AWS_REGION }}
