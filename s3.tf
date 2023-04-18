resource "aws_s3_bucket" "data-lake" {
  bucket = "ndn-data-lake-us-west-2"

  tags = {
    Name        = "data-lake"
    Environment = "Prod"
  }
}
