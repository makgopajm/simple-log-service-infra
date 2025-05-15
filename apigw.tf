/**
    Managed solution for creating and deploying APIs seamlessly.
    It acts as a gateway for RESTful APIs, WebSocket-based communication, and HTTP endpoints,
    providing features like authentication, throttling, and caching.

    Simplifies the process of exposing backend services to the wen as well as privately while
    offering essential management and monitoring capabilities.

**/

# Create API gateway
resource "aws_api_gateway_rest_api" "simple_log_service_api" {
    name = var.product_name
    description = "Simple log service API"
}

/** Configurations for the write endpoint **/

resource "aws_api_gateway_resource" "simple_log_service_api_write" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  parent_id = aws_api_gateway_rest_api.simple_log_service_api.root_resource_id
  path_part = "write-logs"
}

resource "aws_api_gateway_method" "simple_log_service_post"{
    rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
    resource_id = aws_api_gateway_resource.simple_log_service_api_write.id
    http_method = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "simple_log_service_write_integration" {
    rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
    resource_id = aws_api_gateway_resource.simple_log_service_api_write.id
    http_method = aws_api_gateway_method.simple_log_service_post.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY" # For Lambda proxy integration
    #uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.simple_log_service_write_lambda.arn}/invocations"
    uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${module.simple_log_service_write_lambda.function_arn}/invocations" 
}


/** Configurations for the read endpoint **/

resource "aws_api_gateway_resource" "simple_log_service_api_read" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  parent_id = aws_api_gateway_rest_api.simple_log_service_api.root_resource_id
  path_part = "read-logs"
}

resource "aws_api_gateway_method" "simple_log_service_get"{
    rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
    resource_id = aws_api_gateway_resource.simple_log_service_api_read.id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "simple_log_service_read_integration" {
    rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
    resource_id = aws_api_gateway_resource.simple_log_service_api_read.id
    http_method = aws_api_gateway_method.simple_log_service_get.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY" # For Lambda proxy integration
    uri =  "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${module.simple_log_service_read_lambda.function_arn}/invocations"
  
}

resource "aws_api_gateway_deployment" "simple_log_service_api_deployment" {
    depends_on = [ aws_api_gateway_integration.simple_log_service_write_integration,
    aws_api_gateway_integration.simple_log_service_read_integration ]

    rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  
}

resource "aws_api_gateway_stage" "simple_log_service_api_stage" {
    deployment_id = aws_api_gateway_deployment.simple_log_service_api_deployment.id
    rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
    stage_name = var.env
}