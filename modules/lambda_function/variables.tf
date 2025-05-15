variable "function_name" {
    type = string
    description = "The name of the Lambda function"
}

variable "image_uri" {
    type = string
    description = "URI of ECR"
}

variable "timeout" {
    description = "Lambda execution timeout"
    type = number
    default = 300
}

variable "memory_size" {
    description = "Lambda memory in MB"
    type = number
    default = 128
}

variable "environment_variables" {
    description = "Lambda environment variables"
    type = map(string)
    default = {}
}

variable "role_arn" {
    description = "Role ARN"
    type = string
}