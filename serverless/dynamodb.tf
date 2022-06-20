resource "aws_dynamodb_table" "wide-rydes" {
  name = "Rides"
  billing_mode   = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  hash_key = "RideId"

  attribute {
    name = "RideId"
    type = "S"
  }


}
