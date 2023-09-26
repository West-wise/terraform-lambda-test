resource "aws_s3_bucket" "teamcgv-test-bucket" {
  bucket = "teamcgv-test" # 버킷 이름을 고유하게 지정하세요.
}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.teamcgv-test-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.teamcgv-test-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example
  ]

  bucket = aws_s3_bucket.teamcgv-test-bucket.id
  acl    = "public-read"
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.teamcgv-test-bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.add_tag.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }
  depends_on = [aws_lambda_permission.s3_invoke_permission]
}