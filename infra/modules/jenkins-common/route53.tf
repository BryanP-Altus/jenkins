resource "aws_route53_record" "this" {
  count = var.route53_create_alias ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.route53_alias_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
