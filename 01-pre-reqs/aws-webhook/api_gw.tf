# This is the API Gateway resource that will be used to create the webhook handler
resource "aws_api_gateway_rest_api" "webhook" {
  name        = local.base_name
  description = "HCP Packer webhook API for HCP org '${local.hcp_org_name}', project '${local.hcp_project_name}'."
  endpoint_configuration {
    types = ["EDGE"]
  }
}

# This is the deployment of the API Gateway resource
resource "aws_api_gateway_deployment" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  depends_on  = [aws_api_gateway_integration.webhook]

  lifecycle {
    create_before_destroy = true
  }
}

# This is the stage of the API Gateway resource. A stage is a deployment environment for an API Gateway resource.
resource "aws_api_gateway_stage" "webhook" {
  deployment_id = aws_api_gateway_deployment.webhook.id
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  stage_name    = var.api_gateway_stage_name
}

# This is the resource of the API Gateway resource. A resource is a collection of methods and associated configuration for a path in an API.
resource "aws_api_gateway_resource" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
  path_part   = "handler"
}

# This is the method of the API Gateway resource. A method is an action that clients can perform on a resource.
resource "aws_api_gateway_method" "webhook" {
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  resource_id   = aws_api_gateway_resource.webhook.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.X-Hcp-Webhook-Signature" = true
  }
}

# API Gateway execution logging requires a CloudWatch log role to be set up in your API Gateway settings.
# Because this is an account/region-level setting, this is not configured here.
# See https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html?icmpid=apigateway_console_help#set-up-access-logging-permissions

# This is the method settings of the API Gateway resource. A method setting is a configuration for a method in an API.
resource "aws_api_gateway_method_settings" "webhook" {
  count       = var.enable_api_gateway_logging ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  stage_name  = aws_api_gateway_stage.webhook.stage_name
  method_path = "*/*"

  settings {
    logging_level      = var.api_gateway_logging_level
    metrics_enabled    = true
    data_trace_enabled = false
  }

  depends_on = [aws_cloudwatch_log_group.webhook_api_gateway]
}

# This is the CloudWatch log group of the API Gateway resource. A log group is a collection of log streams that are associated with a specific resource.
resource "aws_cloudwatch_log_group" "webhook_api_gateway" {
  count             = var.enable_api_gateway_logging ? 1 : 0
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.webhook.id}/${var.api_gateway_stage_name}"
  retention_in_days = var.log_retention_days
}

# This is the integration of the API Gateway resource. An integration is a configuration for a method in an API.
resource "aws_api_gateway_integration" "webhook" {
  rest_api_id             = aws_api_gateway_rest_api.webhook.id
  resource_id             = aws_api_gateway_resource.webhook.id
  http_method             = aws_api_gateway_method.webhook.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.webhook.invoke_arn
}

# This is the lambda permission of the API Gateway resource. A lambda permission is a configuration for a lambda function in an API.
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.webhook.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.webhook.execution_arn}/*"
}