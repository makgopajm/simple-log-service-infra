# Output API gateway URL

output "api_gw_url" {
  value = aws_api_gateway_deployment.simple_log_service_api_deployment.invoke_url
}

# Output bucket name:

output "s3_bucket_name" {
    value = aws_s3_bucket.simple_log_service_s3_bucket.bucket
  
}

# Output region

output "cognito_region" {
  value = var.region
}

# Output cognito user pool id

output "user_pool_id" {
  value = aws_cognito_user_pool.log_service_user_pool.id
}

# Output cognito user pool client id

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.log_service_user_pool_client.id
}

# output cognito domain

output "cognito_domain" {
  # value = aws_cognito_user_pool_domain.log_service_domain.domain
  value = "${aws_cognito_user_pool_domain.log_service_domain.domain}.auth.us-east-1.amazoncognito.com"
}
