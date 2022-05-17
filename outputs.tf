output "ssm_command" {
  value = "aws ssm start-session --target ${aws_instance.bastion.id} --profile "
}

