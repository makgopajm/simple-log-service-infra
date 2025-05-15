resource "aws_lambda_function" "basic_lambda" {
    function_name = var.function_name
    package_type = "Image"
    image_uri = var.image_uri
    role = var.role_arn
    timeout = 5
    memory_size = 128

    environment {
      variables = var.environment_variables
    }

}