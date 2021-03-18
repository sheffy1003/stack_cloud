resource "aws_s3_bucket" "bucket" {
  bucket = "stackbucksheriff3"
  acl    = "public-read"

  tags = {
    Name        = "stackIT"
    Environment = "stackcloud6"
  }
}