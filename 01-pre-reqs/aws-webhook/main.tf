# This is the data source that is reading the HCP organization. An HCP organization is a collection of projects.  
data "hcp_organization" "current" {}

# This is the data source that is reading the HCP project. An HCP project is a collection of resources.
data "hcp_project" "current" {}


# This is the locals block that is defining the HCP organization name, HCP project name, and the base name for the resources. Locals are different from variables in that they are not passed in as arguments to the module.
locals {
  hcp_org_name     = data.hcp_organization.current.name
  hcp_project_name = data.hcp_project.current.name
  base_name        = "hcp-packer-webhook-handler_${local.hcp_org_name}"
}

# This is the service principal that will be used to create the webhook handler. A service principal is a collection of permissions that are associated with a resource.
resource "hcp_service_principal" "webhook" {
  name   = "hcp-packer-webhook-handler"
  parent = data.hcp_project.current.resource_name
}

# This is the project IAM binding that will be used to bind the service principal to the project. A project IAM binding is a collection of permissions that are associated with a resource.
resource "hcp_project_iam_binding" "webhook" {
  project_id   = data.hcp_project.current.resource_id
  principal_id = hcp_service_principal.webhook.resource_id
  role         = "roles/viewer"
}

# This is the random password that will be used to create the HMAC token. A random password is a collection of characters that are used to create a password.
resource "random_password" "hmac_token" {
  length  = 32
  special = true
}

# This is the secrets manager secret that will be used to store the HMAC token. A secrets manager secret is a collection of secrets that are associated with a resource.
resource "aws_secretsmanager_secret" "hmac_token" {
  name                    = "${local.base_name}-hmac-token"
  description             = "HMAC token for webhook validation. Org: ${local.hcp_org_name}, project: ${local.hcp_project_name}."
  recovery_window_in_days = 0
}

# This is the secrets manager secret version that will be used to store the HMAC token. A secrets manager secret version is a collection of secrets that are associated with a resource.
resource "aws_secretsmanager_secret_version" "hmac_token" {
  secret_id     = aws_secretsmanager_secret.hmac_token.id
  secret_string = random_password.hmac_token.result
}

# This is the HCP notifications webhook that will be used to create the webhook handler. An HCP notifications webhook is a collection of webhooks that are associated with a resource.
resource "hcp_notifications_webhook" "aws" {
  name        = var.hcp_webhook_name
  description = var.hcp_webhook_description
  enabled     = true

  config = {
    hmac_key = aws_secretsmanager_secret_version.hmac_token.secret_string
    url      = "${aws_api_gateway_stage.webhook.invoke_url}/${aws_api_gateway_resource.webhook.path_part}"
  }

  subscriptions = [
    {
      events = [
        {
          actions = ["complete", "delete", "restore", "revoke"]
          source  = "hashicorp.packer.version"
        },
      ]
    },
    ]
}