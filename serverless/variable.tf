provider "aws" {
	region = var.region  
}

variable "region" {
	default = "cn-north-1"
}



#---------------- serverless web hosting via lambda --------

variable "dynamodb_table_name" {
	default = "Rides"
}

variable "lambda_version"     { default = "1.0.0"}


variable "site_domain" {
  type        = string
  description = "The domain name to use for the static site"
  default = "example.com"
}

