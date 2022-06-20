

output "region" {
  description = "AWS region"
  value       = var.region
}


output "api_gateway_endpoint" {
	value = aws_api_gateway_deployment.RequestUnicorn-api-gateway-deployment.invoke_url

}

output "s3_bucket_name" {
	value = aws_s3_bucket.site.id 
}

output "s3_website_endpoint" {
	value = aws_s3_bucket.site.website_endpoint
}


output "cloudfront_url" {
	value = aws_cloudfront_distribution.my-domain.domain_name
}