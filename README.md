# simple-log-service-infra

## Simple Logging Service Infrastructure

This project sets up a serverless logging service on AWS using S3 and Lambda, API gateway and DynamoDB.

CloudFront --> S3 bucket --> API gateway (write & read) --> Lambda functions (write and read) --> DynamoDB (storage)

## Project Structure

- Infrastructure Rep: simple-log-service-infra
- Code Repo: simple-log-service

The components are built and deployed using GitHub Actions CI/CD pipeline with security checks, least privilege IAM roles, and encrypted data handling. To deploy run:

- Workflow: build_deploy_ecr manually

## Features

- Secure AWS Lambda with encrypted data
- Infrastructure as Code (Terraform)
- CI/CD with GitHub Actions
- Pipeline security checks (tfsec, trivy, gitleaks)
- Docker image build + push to ECR
- OIDC-based GitHub authentication to AWS (no static keys)
- Least privilege IAM policies

## Deployment Steps

### 1. Prerequisites

- AWS account with Admin access
- GitHub repository with [OIDC set up](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)

---

### 2. Setup AWS OIDC Role for GitHub Actions

1. Create an IAM role with the following trust policy:
   ```json
   {
     "Effect": "Allow",
     "Principal": {
       "Federated": "arn:aws:iam::<AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringLike": {
         "token.actions.githubusercontent.com:sub": "repo:<your-username>/<your-repo>:*"
       }
     }
   }
Attach a least privilege policy for Terraform/Lambda/ECR deployment.

Copy the role ARN.







