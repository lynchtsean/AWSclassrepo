locals {
  favorite_restaurants = {
    keela    = "keela-bucket"
    mckibbons     = "mckibbons-bucket"
    sesame = "sesame-bucket"
    bordhouse     = "birdhouse-bucket"
    k2     = "k2-bucket"
  }
}

resource "aws_s3_bucket" "top5_buckets" {
  for_each     = local.favorite_restaurants
  bucket       = each.value
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  for_each = aws_s3_bucket.top5_buckets

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
