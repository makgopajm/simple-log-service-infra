/**
    Using AWS IAM to implement least privilege principle.
**/

# DynamoDB resource-based policy - To help manage access to this DynamoDB table.

resource "aws_dynamodb_resource_policy" "dynamodb_resource_policy" {
    resource_arn = aws_dynamodb_table.simple_log_service_dynamodb.arn

    depends_on = [
        module.lambda_writer_role,
        module.lambda_reader_role
    ]

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "AllowLambdaWriteReadAccess",
                Effect = "Allow",
                Principal = {
                    AWS = [
                         module.lambda_writer_role.role_arn,
                         module.lambda_reader_role.role_arn
                    ]
                }
                Action = [
                    "dynamodb:PutItem",
                    "dynamodb:UpdateItem",
                    "dynamodb:DeleteItem",
                    "dynamodb:GetItem",
                    "dynamodb:Scan"


                ],
                Resource = aws_dynamodb_table.simple_log_service_dynamodb.arn
            }
        ]
 } )
  
}

# S3 Bucket Policy - Provides access to the objects stored in the bucket

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.simple_log_service_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontAccessOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.simple_log_service_s3_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.site.id}"
          }
        }
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.simple_log_service_s3_public_block
  ]
}


module "lambda_writer_role" {
  source             = "./modules/iam"
  role_name          = "lambda-writer"
  env                = var.env
  dynamodb_table_arn = aws_dynamodb_table.simple_log_service_dynamodb.arn
  lambda_type        = "writer"
}


module "lambda_reader_role" {
  source             = "./modules/iam"
  role_name          = "lambda-reader"
  env                = var.env
  dynamodb_table_arn = aws_dynamodb_table.simple_log_service_dynamodb.arn
  lambda_type        = "reader"
}




