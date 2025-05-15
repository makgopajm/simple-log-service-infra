/**

**/

# resource "aws_lambda_function" "simple_log_service_write_lambda" {
#     function_name = "${var.product_name}-writer-lambda"
#     #package_type = "Image"
#     handler = "lambda_handler"
#     #image_uri = aws_ecr_repository.simple_log_service_ecr.repository_url
#     role = aws_iam_role.lambda_write_role.arn
#     filename = "build/lambda_handler.zip"
#     runtime = "python3.13"

# }

# resource "aws_lambda_function" "simple_log_service_read_lambda" {
#     function_name = "${var.product_name}-reader-lambda"
#     #package_type = "Image"
#     handler = "lambda_handler"
#     #image_uri = aws_ecr_repository.simple_log_service_ecr.repository_url
#     role = aws_iam_role.lambda_write_role.arn
#     filename = "build/lambda_handler.zip"
#     runtime = "python3.13"

# }

module "simple_log_service_write_lambda" {
    source = "./modules/lambda_function"
    function_name = "${var.product_name}-writer-lambda"
    image_uri = "${module.simple_log_service_ecr_write_image.ecr_repo_uri}:${var.wr_image_tag}"
    role_arn = aws_iam_role.lambda_write_role.arn
    
    environment_variables = {
        LOG_TABLE = aws_dynamodb_table.simple_log_service_dynamodb.name
    }
}

module "simple_log_service_read_lambda" {
    source = "./modules/lambda_function"
    function_name = "${var.product_name}-reader-lambda"
    image_uri = "${module.simple_log_service_ecr_read_image.ecr_repo_uri}:${var.rd_image_tag}"
    role_arn = aws_iam_role.lambda_write_role.arn
    
    environment_variables = {
        LOG_TABLE = aws_dynamodb_table.simple_log_service_dynamodb.name
    }
}