# CloudFront Distribution for Global Low Latency (CDN)
# Sits in front of ALB, caches content at 600+ edge locations worldwide
# Fulfills Conception Phase Requirement #1: "Global Low Latency"

resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "IU Cloud Programming CDN"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"  # US, Europe, Asia-Pacific

  origin {
    domain_name = aws_lb.main.dns_name
    origin_id   = "ALB"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB"
    viewer_protocol_policy = "allow-all"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "iu-cdn"
    Project     = "Cloud Programming"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
