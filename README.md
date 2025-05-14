# simple-log-service-infra

Simple Logging Service Infrastructure

The solution is being built using a serverless approach, which enables developers to focus solely on their code without the complexities of infrastructure management.
The main resources are Amazon S3, AWS Lambda, DynamoDB, coupled with API gateway, offers a power solution for deploying applications in a serverless manager, dynamically scaling resources
in response to demand.

CloudFront --> S3 bucket --> API gateway (write & read) --> Lambda functions (write and read) --> DynamoDB (storage)

Using cross-origin resource sharing (CORS):

What is CORS?

Cross-origin resource sharing (CORS) defines a way for client web applications that are loaded in one domain to interact with resources in a different domain.
test.domain.com --> example.domain.com

1. CORS configuration on S3:

2. CORS configuration on API gateway: