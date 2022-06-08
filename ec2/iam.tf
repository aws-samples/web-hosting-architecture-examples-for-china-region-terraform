


resource "aws_iam_policy" "ec2-iam-policy" {
  name = "web-hosting"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "S3:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": ["${aws_dynamodb_table.wide-rydes.arn}","${aws_dynamodb_table.wide-rydes.arn}/*"]
    }

  ]
}
EOF

}



resource "aws_iam_role" "ec2-iam-role" {
  name = "ec2-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com.cn"
        }
      }

    ]
  })

}

resource "aws_iam_role_policy_attachment" "attach-ec2-role" {
  role       = aws_iam_role.ec2-iam-role.name
  policy_arn = aws_iam_policy.ec2-iam-policy.arn
}


resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.ec2-iam-role.name
}
