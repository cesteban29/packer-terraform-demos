# VARIABLES FILE

# used by the aws provider in the file terraform.tf
variable "region" {
  type        = string
  description = "The AWS region to use."
}

# used by hcp_notifications_webhook in the file main.tf
variable "hcp_webhook_name" {
  type        = string
  description = "Name for the HCP webhook."
  default     = "AWS-Handler"
}

# used by hcp_notifications_webhook in the file main.tf
variable "hcp_webhook_description" {
  type        = string
  description = "Description for the HCP webhook."
  default     = "Handler for AWS image events"
}

# used by aws_secretsmanager_secret in the file secrets.tf
variable "log_retention_days" {
  type        = number
  description = "Number of days to retain CloudWatch logs."
  default     = 14
}

# used by api_gateway_method_settings in the file api_gw.tf
variable "enable_api_gateway_logging" {
  type        = bool
  description = "Whether to enable API Gateway logging."
  default     = false
}

# used by api_gateway_method_settings in the file api_gw.tf
variable "api_gateway_logging_level" {
  type        = string
  description = "Log level for API Gateway execution logging."
  default     = "ERROR"
  validation {
    condition     = contains(["OFF", "ERROR", "INFO"], var.api_gateway_logging_level)
    error_message = "Invalid logging level specified."
  }
}

# used by api_gateway_stage in the file api_gw.tf
variable "api_gateway_stage_name" {
  type        = string
  description = "The name of the stage to deploy the API Gateway to."
  default     = "dev"
}

# used by default_tags in the file terraform.tf
variable "environment" {
  type        = string
  description = "The environment to use."
  default     = "demo"
}

# used by default_tags in the file terraform.tf
variable "owner" {
  type        = string
  description = "The owner of the resources."
  default     = "cesteban"
}
