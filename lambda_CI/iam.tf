#IAM Users
resource "aws_iam_user" "cg-bob" {
  name = "bob"
  tags = {
    Name     = "cg-bob-${var.cgid}"
    Stack    = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_iam_access_key" "cg-bob" {
  user = aws_iam_user.cg-bob.name
}

resource "aws_iam_policy" "AmazonS3ReadOnlyAccess" {
  name        = "AmazonS3ReadOnlyAccess"
  description = "AmazonS3ReadOnlyAccess Polic"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:Get*",
            "s3:List*",
            "s3:Describe*",
            "s3-object-lambda:Get*",
            "s3-object-lambda:List*",
            "s3:PutObject*",
            "s3:HeadObject",
            "lambda:List*",
            "lambda:GetFunction"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}


resource "aws_iam_user_policy_attachment" "access_user_policy" {
  user       = aws_iam_user.cg-bob.name
  policy_arn = aws_iam_policy.AmazonS3ReadOnlyAccess.arn
}
