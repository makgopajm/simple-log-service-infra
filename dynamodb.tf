/**


**/

resource "aws_dynamodb_table" "simple_log_service_dynamodb" {
    name = var.product_name
    billing_mode = "PROVISIONED"
    read_capacity = 1
    write_capacity = 1
    hash_key = "Log_ID"
    range_key = "Timestamp"

    attribute {
      name = "Log_ID"
      type = "S"
    }

    attribute {
      name = "Timestamp"
      type = "S"
    }

    # attribute {
    #   name = "Severity"
    #   type = "S"
    # }

    # attribute {
    #   name = "Message"
    #   type = "S"
    # }
  
}