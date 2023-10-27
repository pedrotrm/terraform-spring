output "public_ip_address_app" {
  value = "http://${aws_instance.vm-aula.public_ip}:8080"
}
