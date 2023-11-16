terraform {
  backend "s3" {
    bucket = "bucket-state-davids"
    key    = "s3/terraform-state-file"
    region = "eu-west-2"
    dynamodb_table = "dynamo-state"
    encrypt = true
  }
}