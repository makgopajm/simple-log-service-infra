# CloudFront only supports certificates in us-east-1.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Create a wildcard SSL certificate and DNS validation.
resource "aws_acm_certificate" "wildcard_cert" {
  provider          = aws.us_east_1
  domain_name       = "*.urbanversatile.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.host_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.wildcard_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
