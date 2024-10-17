check "health_check" {
  data "http" "hashicat_web" {
    url = module.hashicat.catapp_url
  }

  assert {
    condition = data.http.hashicat_web.status_code == 200
    error_message = "${data.http.hashicat_web.url} returned an unhealthy status code"
  }
}

check "ami_version_check" {
  data "aws_instance" "hashicat_current" {
    instance_tags = {
      Name = "demo-hashicat-instance"
    }
  }

  assert {
    condition = data.aws_instance.hashicat_current.ami == data.hcp_packer_image.ubuntu_us_east_1.cloud_image_id
    error_message = "Must use the latest available AMI, ${data.hcp_packer_image.ubuntu_us_east_1.cloud_image_id}."
  }
}
