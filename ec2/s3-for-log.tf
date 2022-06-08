


resource "random_id" "bucket-prefix" {
  byte_length = 6
}

locals {
  log_bucket_name = "${random_id.bucket-prefix.hex}-awslogs-cn-north-1-${var.account_id}"
}

resource "aws_s3_bucket" "log-bucket" {
  bucket = local.log_bucket_name
}


