/**


**/

resource "aws_dynamodb_table" "simple_log_service_dynamodb" {
    name = var.product_name
    billing_mode = "PROVISIONED"
    read_capacity = 1
    write_capacity = 1
    hash_key = "log_id"

    attribute {
      name = "log_id"
      type = "S"
    }

}