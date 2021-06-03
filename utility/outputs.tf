output "utility_instance_public_ip" {
  value = "${aws_instance.utility_instance.public_ip}"
}