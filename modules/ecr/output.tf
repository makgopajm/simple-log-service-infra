
output "basic_ecr" {
    value = aws_ecr_repository.basic_ecr.repository_url
}