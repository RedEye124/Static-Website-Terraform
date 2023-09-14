#create s3 bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}
# setting ownership on the bucket 


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# public access resource

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# s3 acl

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

#index html

resource "aws_s3_bucket_object" "index"{
bucket = aws_s3_bucket.mybucket.id
key = "index.html"
source = "index.html"
acl = "public-read"
content_type = "text/html"
}
# error html

resource "aws_s3_bucket_object" "error"{
bucket = aws_s3_bucket.mybucket.id
key = "error.html"
source = "error.html"
acl = "public-read"
content_type = "text/html"
}
# profile
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key = "profile.png"
  source = "profile.png"
  acl = "public-read"
}

resource "aws_s3_object" "img1" {
    bucket = aws_s3_bucket.mybucket.id
    key = "proimg1.png"
    source = "proimg1.png"
    acl = "public-read"
  
}

resource "aws_s3_object" "img2" {
    bucket = aws_s3_bucket.mybucket.id
    key = "proimg2.png"
    source = "proimg2.png"
    acl = "public-read"
  
}
#website configuration

resource "aws_s3_bucket_website_configuration" "website" {
  
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"

  }
  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example ]
}
