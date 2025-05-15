/**


**/

resource "aws_dynamodb_table" "simple_log_service_dynamodb" {
    name = var.product_name
    billing_mode = "PROVISIONED"
    read_capacity = 1
    write_capacity = 1
    hash_key = "Log_ID"

    attribute {
      name = "Log_ID"
      type = "S"
    }

}