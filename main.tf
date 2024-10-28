module "s3_bucket" {
  source      = "./s3_bucket"  # Path to the S3 bucket module
  bucket_name = "alibashir"     # The name of the S3 bucket
  user_arn    = "arn:aws:iam::891377137882:user/alibashir"  # User ARN with permissions
}
