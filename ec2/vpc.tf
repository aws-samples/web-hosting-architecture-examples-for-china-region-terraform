
################################################################################
# VPC Module
################################################################################



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.3"
  # insert the 23 required variables here

  name = "simple-example"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}