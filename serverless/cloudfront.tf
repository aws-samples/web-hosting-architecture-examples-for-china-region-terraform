



resource "random_id" "bucket-prefix" {
  byte_length = 6
}

locals {
  bucket_name = "${random_id.bucket-prefix.hex}.${var.site_domain}"
}

resource "aws_s3_bucket" "site" {
  bucket = local.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}


resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.site.id
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid":"PublicReadGetObject",
      "Effect": "Allow",
      "Principal" : "*",
      "Action": [
        "S3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.site.arn}",
        "${aws_s3_bucket.site.arn}/*"]
    }
  ]
}
EOF
}


resource "aws_cloudfront_distribution" "my-domain" {
  origin {
    domain_name = aws_s3_bucket.site.website_endpoint
    origin_id   = aws_s3_bucket.site.id
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  enabled             = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.site.id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    
  }

  aliases = [
     "xxx.example.com"
  ]

  # aliases = [
  #    "xxxx.${var.site_domain}"   # 假设域名和证书为 example.com，改为 "xxx.example.com即可"
  #]
  
  #viewer_certificate {
  # acm_certificate_arn = "xxxxxx"  #证书的ARN
  # ssl_support_method  = "sni-only" 
  #}
}


