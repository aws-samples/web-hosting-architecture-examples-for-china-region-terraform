provider "aws" {
	region = var.region
}

variable "region" {
	default = "cn-north-1"
}

# variables
variable "key_name" {
	default = "linux_BJS"

}

# ------------- EC2 web hosting -----------


variable "elb_account_id" {
	default = "638102146993"  #cn-north-1, DO NOT revise
	# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
}

variable "elb_prefix" {
	default = "lb-terraform-logs"   
	
}

variable "account_id" {
	default = "287439122014"
}


variable "ec2_ami_id" {
	default = "ami-0dd06fbcbb6cf837f"   # cn-north-1
	
}


variable "ec2_instance_type" {
	default = "t2.micro"
}


variable "site_domain" {
  description = "The domain name to use for the static site"
  default = "tiange.a2z.org.cn"
}

