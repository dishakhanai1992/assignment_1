output "key_name" {
  value       = aws_key_pair.deployer1.key_name
  description = "key name"
}

output "instance_id" {
  value       = aws_instance.ubuntu.id
  description = "Instance id"
}

output "instance_pub_ip_ubuntu" {
  value       = "Ubuntu IP is: ${aws_instance.ubuntu.public_ip}"
  description = "Instance Public IP UBUNTU"
}