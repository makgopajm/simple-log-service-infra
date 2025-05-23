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
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = aws_api_gateway_authorizer.log_service_authorizer.id
}

resource "aws_api_gateway_method_response" "post_write_logs_200" {
   depends_on  = [aws_api_gateway_method.simple_log_service_post]
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id = aws_api_gateway_resource.simple_log_service_api_write.id
  http_method = "POST"
  status_code = "200" # or "201" if your Lambda returns that

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "post_write_logs_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id = aws_api_gateway_resource.simple_log_service_api_write.id
  http_method = "POST"
  status_code = aws_api_gateway_method_response.post_write_logs_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'https://logging-service.urbanversatile.com'"
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_integration.simple_log_service_write_integration]

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

resource "aws_api_gateway_method" "simple_log_service_writer_options" {
  rest_api_id   = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id   = aws_api_gateway_resource.simple_log_service_api_write.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_write_logs" {
  rest_api_id             = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id             = aws_api_gateway_resource.simple_log_service_api_write.id
  http_method             = aws_api_gateway_method.simple_log_service_writer_options.http_method
  type                    = "MOCK"
  integration_http_method = "OPTIONS"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_write_logs_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id = aws_api_gateway_resource.simple_log_service_api_write.id
  http_method = aws_api_gateway_method.simple_log_service_writer_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_write_logs_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id = aws_api_gateway_resource.simple_log_service_api_write.id
  http_method = aws_api_gateway_method.simple_log_service_writer_options.http_method
  status_code = aws_api_gateway_method_response.options_write_logs_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "allow_apigw_invoke_write" {
  statement_id  = "AllowAPIGatewayInvokeWrite"
  action        = "lambda:InvokeFunction"
  function_name = module.simple_log_service_write_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.simple_log_service_api.execution_arn}/*/*/write-logs"
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
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = aws_api_gateway_authorizer.log_service_authorizer.id
}

resource "aws_api_gateway_method_response" "read_logs_200" {
  depends_on = [aws_api_gateway_method.simple_log_service_get]
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id = aws_api_gateway_resource.simple_log_service_api_read.id
  http_method = "GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "read_logs_200" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id = aws_api_gateway_resource.simple_log_service_api_read.id
  http_method = aws_api_gateway_method.simple_log_service_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://logging-service.urbanversatile.com'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_integration.simple_log_service_read_integration]
}

resource "aws_api_gateway_integration" "simple_log_service_read_integration" {
    rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
    resource_id = aws_api_gateway_resource.simple_log_service_api_read.id
    http_method = aws_api_gateway_method.simple_log_service_get.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY" # For Lambda proxy integration
    uri =  "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${module.simple_log_service_read_lambda.function_arn}/invocations"
  
}


# OPTIONS method for /read-logs

resource "aws_api_gateway_method" "simple_log_service_options" {
  rest_api_id   = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id   = aws_api_gateway_resource.simple_log_service_api_read.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "simple_log_service_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id             = aws_api_gateway_resource.simple_log_service_api_read.id
  http_method             = aws_api_gateway_method.simple_log_service_options.http_method
  type                    = "MOCK"
  integration_http_method = "OPTIONS"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "simple_log_service_options_response" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id = aws_api_gateway_resource.simple_log_service_api_read.id
  http_method = aws_api_gateway_method.simple_log_service_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "simple_log_service_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
  resource_id = aws_api_gateway_resource.simple_log_service_api_read.id
  http_method = aws_api_gateway_method.simple_log_service_options.http_method
  status_code = aws_api_gateway_method_response.simple_log_service_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "allow_apigw_invoke_read" {
  statement_id  = "AllowAPIGatewayInvokeRead"
  action        = "lambda:InvokeFunction"
  function_name = module.simple_log_service_read_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.simple_log_service_api.execution_arn}/*/*/read-logs"
}

# Deployment of the API gateway

resource "aws_api_gateway_deployment" "simple_log_service_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id

  depends_on = [
    # POST /write-logs
    aws_api_gateway_method.simple_log_service_post,
    aws_api_gateway_integration.simple_log_service_write_integration,
    aws_api_gateway_method_response.post_write_logs_200,
    aws_api_gateway_integration_response.post_write_logs_200,

    # OPTIONS /write-logs (CORS preflight)
    aws_api_gateway_method.simple_log_service_writer_options,
    aws_api_gateway_integration.simple_log_service_options_integration,
    aws_api_gateway_method_response.options_write_logs_200,
    aws_api_gateway_integration_response.options_write_logs_200,

    # GET /read-logs
    aws_api_gateway_method.simple_log_service_get,
    aws_api_gateway_integration.simple_log_service_read_integration,
    aws_api_gateway_method_response.read_logs_200,
    aws_api_gateway_integration_response.read_logs_200,

    # OPTIONS /read-logs (CORS preflight)
    aws_api_gateway_method.simple_log_service_options,
    aws_api_gateway_integration.simple_log_service_options_integration,
    aws_api_gateway_method_response.simple_log_service_options_response,
    aws_api_gateway_integration_response.simple_log_service_options_integration_response
  ]

  triggers = {
    redeployment = timestamp()
  }
}


resource "aws_api_gateway_stage" "simple_log_service_api_stage" {
    deployment_id = aws_api_gateway_deployment.simple_log_service_api_deployment.id
    rest_api_id = aws_api_gateway_rest_api.simple_log_service_api.id
    stage_name = var.env
}
