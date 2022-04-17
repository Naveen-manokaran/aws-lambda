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
  vpc_config {
    subnet_ids         = [aws_subnet.my-pri_subnet.id]
    security_group_ids = [aws_security_group.ssh_from_office.id]
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
resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents",
       "xray:PutTraceSegments",
       "xray:PutTelemetryRecords",
       "xray:GetSamplingRules",
       "xray:GetSamplingTargets",
       "xray:GetSamplingStatisticSummaries"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_flow_log" "test_flow_log" {
  vpc_id       = aws_vpc.my-vpc.id
  traffic_type = "ALL"
  # other required fields here
}
resource "aws_subnet" "my-pri_subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.2.0/25"
  availability_zone = "us-east-2b"
}

resource "aws_security_group" "ssh_from_office" {
  name        = "ssh_from_office"
  description = "Allow ssh from office"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_kms_key" "microservice" {
  description         = "Key for legacy microservice secret encryption/decryption"
  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_kms_alias" "microservice_kms_alias" {
  name          = "alias/microservice"
  target_key_id = aws_kms_key.microservice.key_id
}