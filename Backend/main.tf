provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "ecom-biekro-bucket"

  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "ecom-biekro-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}