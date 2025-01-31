# This is a data source that is reading the IAM policy document for the lambda assume role. The role is used to assume the lambda role.
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# This is the IAM role that will be used to execute the lambda function. An IAM role is a collection of permissions that are associated with a resource.
resource "aws_iam_role" "lambda_execution_role" {
  name                = "${local.base_name}-lambda-role"
  description         = "Execution role for the HCP Packer webhook handler Lambda function for HCP org '${local.hcp_org_name}', project '${local.hcp_project_name}'."
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role.json
}

# This is the IAM role policy that will be used to manage the AMI. An IAM role policy is a collection of permissions that are associated with a resource.
resource "aws_iam_role_policy" "lambda_manage_ami" {
  name   = "lambda-manage-ami"
  role   = aws_iam_role.lambda_execution_role.id
  policy = data.aws_iam_policy_document.lambda_manage_ami.json
}

# This is the IAM role policy that will be used to get the secrets. An IAM role policy is a collection of permissions that are associated with a resource.
resource "aws_iam_role_policy" "lambda_get_secrets" {
  name   = "lambda-get-secrets"
  role   = aws_iam_role.lambda_execution_role.id
  policy = data.aws_iam_policy_document.lambda_get_secrets.json
}

# This is the IAM role policy attachment that will be used to attach the basic execution role to the lambda execution role.
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# This is the data source that is reading the IAM policy document for the lambda manage AMI. The policy is used to manage the AMI.
data "aws_iam_policy_document" "lambda_manage_ami" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeImages",
      "ec2:*ImageDeprecation",
      "ec2:ModifyImageAttribute",
      "ec2:DeregisterImage",
      "ec2:DescribeSnapshots",
      "ec2:DeleteSnapshot",
    ]

    resources = ["*"]
  }
}

# This is the data source that is reading the IAM policy document for the lambda get secrets. The policy is used to get the secrets.
data "aws_iam_policy_document" "lambda_get_secrets" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      aws_secretsmanager_secret.hmac_token.arn,
    ]
  }
}

# This is the data source that is reading the archive file for the lambda function. The archive file is used to create the lambda function.
data "archive_file" "webhook_lambda" {
  type        = "zip"
  source_file = "${path.module}/function/lambda_function.py"
  output_path = "${path.module}/function/lambda_function.zip"
}

# This is the lambda function that will be used to create the webhook handler. A lambda function is a function that is executed by AWS Lambda.
resource "aws_lambda_function" "webhook" {
  function_name    = local.base_name
  description      = "HCP Packer webhook handler for HCP org '${local.hcp_org_name}', project '${local.hcp_project_name}'."
  filename         = data.archive_file.webhook_lambda.output_path
  source_code_hash = data.archive_file.webhook_lambda.output_base64sha256
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  timeout          = 30

  environment {
    variables = {
      HMAC_TOKEN_ARN     = aws_secretsmanager_secret.hmac_token.arn
    }
  }

  depends_on = [aws_cloudwatch_log_group.webhook_function]
}

# This is the CloudWatch log group that will be used to store the logs for the lambda function. A CloudWatch log group is a collection of log streams that are associated with a specific resource.
resource "aws_cloudwatch_log_group" "webhook_function" {
  name              = "/aws/lambda/${local.base_name}"
  retention_in_days = var.log_retention_days
}

