/**

**/

resource "aws_ecr_repository" "simple_log_service_ecr" {
    name = var.product_name
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
      
    }
  
}