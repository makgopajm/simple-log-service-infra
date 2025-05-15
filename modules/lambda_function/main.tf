resource "aws_lambda_function" "basic_lambda" {
    function_name = var.function_name
    package_type = "Image"
    image_uri = var.image_uri
    role = var.role_arn
    runtime = var.runtime
    timeout = var.timeout
    memory_size = var.memory_size

    environment {
      variables = var.environment_variables
    }

}