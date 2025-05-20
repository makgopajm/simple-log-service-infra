variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  type        = string
}

variable "lambda_type" {
  description = "Type of Lambda role: reader or writer"
  type        = string
  validation {
    condition     = contains(["reader", "writer"], var.lambda_type)
    error_message = "lambda_type must be 'reader' or 'writer'."
  }
}
