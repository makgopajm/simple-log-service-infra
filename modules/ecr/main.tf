resource "aws_ecr_repository" "basic_ecr" {
    name = var.ecr_name
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
      
    }
  
}