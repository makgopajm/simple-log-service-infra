
/**
    S3 Client-side web applications"

**/

# Creating an S3 bucket

resource "aws_s3_bucket" "simple_log_service_s3_bucket" {
    bucket ="${var.product_name}-${data.aws_caller_identity.current.id}"
    force_destroy = true
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

resource "aws_s3_bucket_public_access_block" "simple_log_service_s3_public_block" {
  bucket =  aws_s3_bucket.simple_log_service_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/**
    Cross-origin resource sharing (CORS) - define a way for client web applications that are loaded in one domain to interact with resources in a different domain
**/

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.simple_log_service_s3_bucket.id

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://logging-service.urbanversatile.com"]
    max_age_seconds = 3000
  }
}


