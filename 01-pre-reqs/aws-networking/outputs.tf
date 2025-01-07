# Outputs file
output "demo_env_vpc_name" {
  value = aws_vpc.demo_env.tags.name
}
output "demo_env_vpc_id" {
  value = aws_vpc.demo_env.id
}

output "demo_env_subnet_name" {
  value = aws_subnet.demo_default_subnet.tags.name
}

output "demo_env_subnet_id" {
  value = aws_subnet.demo_default_subnet.id
}

output "demo_env_security_group_name" {
  value = aws_security_group.public_access_security_group.name
}

output "demo_env_security_group_id" {
  value = aws_security_group.public_access_security_group.id
}