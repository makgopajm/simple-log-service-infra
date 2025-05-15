
output "ecr_repo_uri" {
    value = aws_ecr_repository.basic_ecr.repository_url
}