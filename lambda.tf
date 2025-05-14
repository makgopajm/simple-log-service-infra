/**

**/

resource "aws_lambda_function" "simple_log_service_write_lambda" {
    function_name = "${var.product_name}-writer-lambda"
    #package_type = "Image"
    handler = "lambda_handler"
    #image_uri = aws_ecr_repository.simple_log_service_ecr.repository_url
    role = aws_iam_role.lambda_write_role.arn
    filename = "build/lambda_handler.zip"
    runtime = "python3.13"

}

resource "aws_lambda_function" "simple_log_service_read_lambda" {
    function_name = "${var.product_name}-reader-lambda"
    #package_type = "Image"
    handler = "lambda_handler"
    #image_uri = aws_ecr_repository.simple_log_service_ecr.repository_url
    role = aws_iam_role.lambda_write_role.arn
    filename = "build/lambda_handler.zip"
    runtime = "python3.13"

}