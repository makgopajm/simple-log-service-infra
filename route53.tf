# Route 53 hosted zone.
data "aws_route53_zone" "host_zone" {
  name = "urbanversatile.com."
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.host_zone.zone_id
  name    = "logging-service.urbanversatile.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}
