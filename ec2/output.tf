

output "region" {
  description = "AWS region"
  value       = var.region
}



output "cloudfront_url" {
	value = aws_cloudfront_distribution.my-domain.domain_name
}

output "alb_url" {
	value = "http://${aws_lb.backend.dns_name}:8080"
}

output "web-alb-url" {
	value = "http://${aws_lb.web-hosting.dns_name}"
}