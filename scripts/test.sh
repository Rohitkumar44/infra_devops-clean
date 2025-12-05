#!/bin/bash
ALB=$(terraform -chdir=terraform output -raw alb_dns)
echo "Testing ALB: http://$ALB"

echo "GET /"
curl -s http://$ALB/

echo -e "\n\nGET /health"
curl -s http://$ALB/health
