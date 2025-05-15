/**
    Backend is configured before variables or expressions are evaluated
**/

terraform {
  backend "s3" {
    bucket         = "jbterraformwork"
    # key            = "simple-log-service-infra/${terraform.workspace}/terraform.tfstate"
    region         = "eu-west-1"
  }
}