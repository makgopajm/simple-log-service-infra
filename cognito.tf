
# Creating User Pool

resource "aws_cognito_user_pool" "log_service_user_pool" {
    name = "${var.product_name}-user-pool"
}


# User Pool Client

resource "aws_cognito_user_pool_client" "log_service_user_pool_client" {
  name         = "${var.product_name}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.log_service_user_pool.id
  generate_secret = false
  allowed_oauth_flows                  = ["code","implicit"]
  allowed_oauth_scopes                = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = ["https://${var.domain_name}/"]
  logout_urls                          = ["https://${var.domain_name}/"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "log_service_domain" {
  domain       = "${var.product_name}-auth"
  user_pool_id = aws_cognito_user_pool.log_service_user_pool.id
}


# 4. Cognito Authorizer for API Gateway
resource "aws_api_gateway_authorizer" "log_service_authorizer" {
  name                   = "${var.product_name}-cognito-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.simple_log_service_api.id
  identity_source        = "method.request.header.Authorization"
  type                   = "COGNITO_USER_POOLS"
  provider_arns          = [aws_cognito_user_pool.log_service_user_pool.arn]
}