# Outputs file
output "instance_url" {
  value = "http://${aws_eip.eip.public_dns}"
}

output "instance_ip" {
  value = "http://${aws_eip.eip.public_ip}"
}