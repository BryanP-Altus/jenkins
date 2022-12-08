resource "aws_lb" "this" {
  name                       = "${var.name_prefix}-crtl-alb"
  internal                   = var.alb_type_internal
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_security_group[0].id]
  subnets                    = var.alb_subnet_ids
  enable_deletion_protection = true
  drop_invalid_header_fields = true

  dynamic "access_logs" {
    for_each = var.alb_enable_access_logs ? [true] : []
    content {
      bucket  = var.alb_access_logs_bucket_name
      prefix  = var.alb_access_logs_s3_prefix
      enabled = true
    }
  }
}