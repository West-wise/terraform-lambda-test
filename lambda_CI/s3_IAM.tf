#IAM Users
resource "aws_iam_user" "cg-kitri" {
  name = "kitri"
  tags = {
    Name     = "cg-kitri-${var.cgid}"
    Stack    = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}


resource "aws_iam_access_key" "cg-kitri" {
  user = aws_iam_user.cg-kitri.name
}

resource "aws_iam_policy" "s3_bucket_acl_policy" {
  name        = "s3-bucket-acl-policy"
  description = "IAM policy for managing S3 bucket ACL"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutBucketAcl",
        ],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::your-bucket-name",
      },
    ],
  })
}


resource "aws_iam_role" "s3_bucket_acl_role" {
  name = "s3-bucket-acl-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com", # 예시로 Lambda 서비스에게 권한을 부여
        },
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "s3_bucket_acl_attachment" {
  name       = "s3-bucket-acl-attachment"
  policy_arn = aws_iam_policy.s3_bucket_acl_policy.arn
  roles      = [aws_iam_role.s3_bucket_acl_role.name]
}


resource "aws_iam_user_policy_attachment" "s3_bucket_acl_attachment" {
  user       = aws_iam_user.cg-kitri.name
  policy_arn = aws_iam_policy.s3_bucket_acl_policy.arn
}
