# Simple Logging Service Infrastructure

This project implements a **secure, serverless logging platform on AWS**, designed for scalable log ingestion and retrieval. It follows cloud-native best practices including:

- **Secure Authentication**
- **Serverless and Scalable Architecture**
- **Infrastructure as Code (Terraform)**
- **Least privilege and IAM Control**
- **CI/CD using GitHub Actions**
- **Observability-Ready**
- **Encrypted data at rest and in transit**
- **Security scanning integrated into the pipeline**
- **Tested for Common Security Issues**

## Architecture Diagram

![Logging Flow Architecture](./assets/logging-architecture-diagram.png)

<sup>_Diagram: CloudFront ➝ S3 (Frontend) ➝ API Gateway ➝ Lambda ➝ DynamoDB (Storage)_</sup>

## Project Structure

| Component               | Description                                      |
|------------------------|--------------------------------------------------|
| `simple-log-service-infra` | Terraform code and GitHub Actions pipelines       |
| `simple-log-service`       | Source code: Lambda functions & frontend (if any) |

## How to Deploy



### 1️. Prerequisites

- AWS Account (Admin role for setup)
- GitHub Repository connected to AWS via OIDC
- Terraform and Docker installed locally (optional for dev)
- Secrets added to GitHub repository:
  - `AWS_REGION`
  - `AWS_ROLE_ARN`
  - 'TOKEN'
  - 'AWS_ACCOUNT'

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

Attach a least privilege policy to allow:
- Lambda deployments
- DynamoDB and API Gateway updates
- ECR push/pull access
- Terraform resource creation
- (Optional) Secrets Manager or CloudWatch access

Save the Role ARN and add it to GitHub as AWS_ROLE_ARN.

#### Running the CI/CD Workflow

To deploy your infrastructure and application:

- Go to your GitHub repository: **simple-log-service-infra** 
- Open the Actions tab
- Locate the **build_deploy_ecr** workflow
- Click "Run workflow" (manual trigger)

#### This will:

- Build Docker images (e.g., for Lambda functions)
- Run tfsec, trivy, gitleaks
- Push images to ECR
- Deploy infrastructure and Lambda functions

## Monitoring & Observability

1. View metrics in CloudWatch metrics
2. View logs in CloudWatch Logs
3. (Optional) Enable AWS X-Ray for tracing

**Security checks and Testing**

1. The API should only allow the frontend origin (https://your-domain) to call it: curl -X OPTIONS https://your-api-url/dev/read-logs \
  -H "Origin: https://evil.com" \
  -H "Access-Control-Request-Method: GET" \
  -i
2. Unauthenticated Access Check - Try accessing the protected endpoint without a token: curl -X GET https://<your-api>/{stage}/read-logs
3. Tampered Token Check - Use a fake or tampered token: curl -X GET https://<your-api>/{stage}/read-logs -H "Authorization: Bearer faketoken123"
   





