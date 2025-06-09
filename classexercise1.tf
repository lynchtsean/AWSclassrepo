locals {
  favorite_restaurants = {
    chickfila    = "keela-bucket"
    in_n_out     = "mckibbons-bucket"
    pandaexpress = "sesame-bucket"
    chipotle     = "birdhouse-bucket"
    fiveguys     = "k2-bucket"
  }
}

resource "aws_s3_bucket" "my_buckets" {
  for_each     = local.favorite_restaurants
  bucket       = each.value
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  for_each = aws_s3_bucket.my_buckets

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
