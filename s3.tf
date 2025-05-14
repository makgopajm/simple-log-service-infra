
/**
    S3 Client-side web applications"

**/

# Creating an S3 bucket

resource "aws_s3_bucket" "simple_log_service_s3_bucket" {
    bucket ="${var.product_name}-992382425379"
    provider = aws.use1

}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

# Enable static website hosting on the S3 bucket

resource "aws_s3_bucket_website_configuration" "simple_log_service_s3_website" {
    bucket = aws_s3_bucket.simple_log_service_s3_bucket.bucket

    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "error.html"
    }
  
}

/**
    Cross-origin resource sharing (CORS) - define a way for client web applications that are loaded in one domain to interact with resources in a different domain
**/

# resource "aws_s3_bucket_cors_configuration" "simple_log_service_s3_cors" {
#   bucket = aws_s3_bucket.simple_log_service_s3_bucket.bucket

#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["POST","GET", "OPTION"]
#     allowed_origins = ["api.gateway.com"]
#   }
# }

