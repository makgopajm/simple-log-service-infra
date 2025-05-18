# Output API gateway URL

output "api_gw_url" {
  value = aws_api_gateway_deployment.simple_log_service_api_deployment.invoke_url
}

# Output bucket name:

output "s3_bucket_name" {
    value = aws_s3_bucket.simple_log_service_s3_bucket.bucket
  
}