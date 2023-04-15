# Creating an s3 bucket for the tf backend
resource "aws_s3_bucket" "tf_backend" {
  bucket = "remotebackend-terraform"
  tags = {
    "Name" = "remotebackend-terraform"
  }
}

# making the bucket private 
resource "aws_s3_bucket_acl" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  acl    = "private"
}

# enabling versioning for the bucket
resource "aws_s3_bucket_versioning" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Applying server side configuration to the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Blocking public access to the bucket
resource "aws_s3_bucket_public_access_block" "tf_backend" {
  bucket                  = aws_s3_bucket.tf_backend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

# Creating an object resorce to store the remote state
resource "aws_s3_object" "tf_backend" {
  bucket                 = aws_s3_bucket.tf_backend.id
  key                    = "tf-backend/"
  server_side_encryption = "AES256"
}
