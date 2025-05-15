/**
    Using AWS IAM to implement least privilege principle.
**/

# DynamoDB resource-based policy - To help manage access to this DynamoDB table.

resource "aws_dynamodb_resource_policy" "dynamodb_resource_policy" {
    resource_arn = aws_dynamodb_table.simple_log_service_dynamodb.arn
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "AllowLambdaWriteReadAccess",
                Effect = "Allow",
                Principal = {
                    AWS = [
                        "${aws_iam_role.lambda_write_role.arn}",
                        "arn:aws:iam::016015284752:role/GitHub_IAM_Role",
                        "arn:aws:iam::016015284752:user/JB_Admin" # 2 for reader and writer lambda IAM role

                    ]
                }
                Action = [
                    "dynamodb:PutItem",
                    "dynamodb:UpdateItem",
                    "dynamodb:DeleteItem",
                    "dynamodb:GetItem",
                    "dynamodb:Scan"


                ],
                Resource = "${aws_dynamodb_table.simple_log_service_dynamodb.arn}"
            }
        ]
 } )
  
}

# S3 Bucket Policy - Provides access to the objects stored in the bucket

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
    bucket = aws_s3_bucket.simple_log_service_s3_bucket.id
    policy = jsonencode(
        {
            Version = "2012-10-17",
            Statement = [
                {
                    Sid = "PublicAccess",
                    Effect = "Allow",
                    Principal = "*",
                    Action = "s3:GetObject",
                    Resource = "${aws_s3_bucket.simple_log_service_s3_bucket.arn}/*"
                }
            ]
        }
    )
  
}

# Lambda Execution role - To allow lambda to read and write from DynamoDB table and CloudWatch Logs

resource "aws_iam_role" "lambda_write_role" {
    name ="${var.product_name}"

    assume_role_policy = jsonencode(
        {
            Version = "2012-10-17",
            Statement = [
                {
                    Effect = "Allow",
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    },
                    Action = "sts:AssumeRole"
                }
            ]
        }
    )
  
}

resource "aws_iam_policy" "lambda_dynamodb_logs_policy" {
    name = var.env
    description = "Allows Lambda to access DynamoDB and CloudWatch Logs"

    policy = jsonencode(
        {
            Version = "2012-10-17",
            Statement = [
                {
                    Sid = "DynamoDBAccess",
                    Effect = "Allow",
                    Action = [
                        "dynamodb:GetItem",
                        "dynamodb:PutItem",
                        "dynamodb:UpdateItem",
                        "dynamodb:DeleteItem"
                    ],
                     Resource = "${aws_dynamodb_table.simple_log_service_dynamodb.arn}"
                },
                {
                    Sid = "CloudWatchLogsAccess",
                    Effect= "Allow",
                    Action = [
                        "logs:CreatLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                    ],
                    Resource = "*" # Come back and change
                }
            ]
        }
    )
  
}