resource "aws_lambda_function" "test_lambda" {
  #filename         = var.filename
  function_name = var.function_name
  package_type  = var.package_type
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler
  image_uri     = var.image_uri
  #source_code_hash = filebase64sha256("genie_api.zip")
  runtime = var.runtime
  tracing_config {
    mode = var.mode
  }
  environment {
    variables = var.variables
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = var.iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}



