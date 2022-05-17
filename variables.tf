variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "aws_shared_credentials_file" {
  description = "AWS credentail file"
  default     = "~/.aws/credentials"
}

variable "stack" {
  description = "Name of the stack."
  default     = "default"
}

variable "vpc_id" {
  description = "ID of VPC"
}

variable "az" {
  description = "EC2 AZ"
}

variable "ami" {
  description = "EC2 AMI"
  default     = "ami-02c3627b04781eada"
}

variable "key_name" {
  description = "EC2 key name"
}

variable "subnet" {
  description = "EC2 subnet"
}
