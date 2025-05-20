resource "aws_iam_role" "lambda_role" {
  name = "${var.role_name}-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.role_name}-policy-${var.env}"
  description = "Policy for ${var.role_name}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      var.lambda_type == "writer" ? [
        {
          Sid    = "WriterDynamoDBAccess",
          Effect = "Allow",
          Action = [
            "dynamodb:PutItem",
            "dynamodb:UpdateItem",
            "dynamodb:DeleteItem"
          ],
          Resource = var.dynamodb_table_arn
        }
      ] : [],
      var.lambda_type == "reader" ? [
        {
          Sid    = "ReaderDynamoDBAccess",
          Effect = "Allow",
          Action = [
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query"
          ],
          Resource = var.dynamodb_table_arn
        }
      ] : [],
      [
        {
          Sid    = "CloudWatchLogsAccess",
          Effect = "Allow",
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = "*"
        },
        {
          Sid    = "ECRAccess",
          Effect = "Allow",
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetAuthorizationToken"
          ],
          Resource = "*"
        }
      ]
    )
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
