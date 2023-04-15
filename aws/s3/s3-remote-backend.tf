# Creating an s3 bucket for the tf backend
resource "aws_s3_bucket" "tf_backend" {
  bucket = "tf-remote-backend"

  tags = {
    "Name" = "tf-remote-backend"
  }
}

# making the bucket private 
resource "aws_s3_bucket_acl" "tf_backend_acl" {
  bucket = aws_s3_bucket.tf_backend.id
  acl    = "private"
}

# enabling versioning for the bucket
resource "aws_s3_bucket_versioning" "tf_backend_versioning" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Applying server side configuration to the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "tf-tf_backend_encryption" {
  bucket = aws_s3_bucket.tf_backend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
