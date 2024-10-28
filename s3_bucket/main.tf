provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "restricted_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.restricted_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSpecificUserReadWriteList"
        Effect    = "Allow"
        Principal = {
          AWS = var.user_arn
        }
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ]
        Resource = [
          "${aws_s3_bucket.restricted_bucket.arn}",
          "${aws_s3_bucket.restricted_bucket.arn}/*"
        ]
      },
      {
        Sid       = "DenyOtherUsersAccess"
        Effect    = "Deny"
        Principal = {
          AWS = "*"
        }
        Action = [
          "s3:*"
        ]
        Resource = [
          "${aws_s3_bucket.restricted_bucket.arn}",
          "${aws_s3_bucket.restricted_bucket.arn}/*"
        ]
        Condition = {
          StringNotEquals = {
            "aws:PrincipalArn": var.user_arn
          }
        }
      }
    ]
  })
}
