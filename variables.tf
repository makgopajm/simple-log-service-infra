
/**
    
    Input variables let you customize aspects of Terraform modules without altering the module's own source code
    This functionality allowes you to share modules across different Terraform configurations, making your module composable and resuable.

**/

variable "product_name" {
    type = string
    default = "log-service"
    description = "Product name"
  
}


variable "region" {
    type = string
    default = "us-east-1"
    description = "AWS region"
  
}


variable "env" {
    type = string
    default = "dev"
    description = "Environment namer"
  
}

variable "wr_image_tag" {
  description = "ECR Image Tag"
  default = "5"
}

variable "rd_image_tag" {
  description = "ECR Image Tag"
  default = "6"
}

variable "domain_name" {
  description = "Domain name"
}