
# security group
resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "SG for ALB TLS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }




  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


}

# bucket policy

resource "aws_s3_bucket_policy" "allow_access_from_elb_access_logs" {
  bucket = aws_s3_bucket.log-bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws-cn:iam::${var.elb_account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws-cn:s3:::${aws_s3_bucket.log-bucket.id}/${var.elb_prefix}/AWSLogs/${var.account_id}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws-cn:s3:::${aws_s3_bucket.log-bucket.id}/${var.elb_prefix}/AWSLogs/${var.account_id}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws-cn:s3:::${aws_s3_bucket.log-bucket.id}"
    }
  ]
}
EOF

}


# ALB front-end
resource "aws_lb" "web-hosting" {
  name               = "alb-front-end"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.log-bucket.id
    prefix  = "${var.elb_prefix}"
    enabled = true
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

}


# front-end target group
resource "aws_lb_target_group" "web-server" {
  name     = "tf-example-lb-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id  
}


# front-end listener

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-hosting.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-server.arn
  }
}

# backend ALB

resource "aws_lb" "backend" {
  name               = "backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.log-bucket.id
    prefix  = "${var.elb_prefix}"
    enabled = true
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

}


# backend target group

resource "aws_lb_target_group" "web-backend" {
  name     = "tf-example-lb-backend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id  
}

# backend listener

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "8080"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-backend.arn
  }
}

