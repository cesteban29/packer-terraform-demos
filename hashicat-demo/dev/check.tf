check "health_check" {
  data "http" "hashicat_web" {
    url = module.hashicat.instance_url
  }

  assert {
    condition = data.http.hashicat_web.status_code == 200
    error_message = "${data.http.hashicat_web.url} returned an unhealthy status code"
  }
}

check "ami_version_check" {
  data "aws_instance" "hashicat_current" {
    filter {
      name   = "tag:Name"
      values = ["${var.prefix}-demo-instance"]
    }

    filter {
      name   = "instance-state-name"
      values = ["running"]
    }
  }

  assert {
    condition = data.aws_instance.hashicat_current.ami == data.hcp_packer_artifact.hashicat-artifact.external_identifier
    error_message = "Must use the latest available AMI, ${data.hcp_packer_artifact.hashicat-artifact.external_identifier}."
  }
}
