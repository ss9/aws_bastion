resource "aws_instance" "bastion" {
  ami                                  = var.ami
  associate_public_ip_address          = false
  availability_zone                    = var.az
  # cpu_core_count                       = 1
  # cpu_threads_per_core                 = 1
  disable_api_termination              = false
  ebs_optimized                        = false
  get_password_data                    = false
  hibernation                          = false
  iam_instance_profile                 = aws_iam_instance_profile.ssm_role.id
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  ipv6_address_count                   = 0
  ipv6_addresses                       = []
  key_name                             = var.key_name
  monitoring                           = false
  secondary_private_ips                = []
  security_groups                      = []
  source_dest_check                    = true
  subnet_id                            = var.subnet
  tags = {
    "Name" = "${var.stack}-bastion-ec2"
  }
  tenancy                = "default"
  vpc_security_group_ids = [aws_security_group.deny_inbound.id, ]
}

resource "aws_security_group" "deny_inbound" {
  description = "for bastion EC2"
  name        = "${var.stack}-deny-inbound"
  vpc_id      = var.vpc_id
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
  ]
  ingress = []
  tags = {
    "Name" = "${var.stack}-deny-inbound-sg"
  }
}

resource "aws_iam_instance_profile" "ssm_role" {
  name = "${var.stack}-ssm-role"
  role = aws_iam_role.ssm_ec2_role.name
}

resource "aws_iam_role" "ssm_ec2_role" {
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Sid = ""
        },
      ]
    }
  )
  description           = "Allows EC2 instances to call AWS services like CloudWatch and Systems Manager on your behalf."
  force_detach_policies = false
  managed_policy_arns = [
    aws_iam_policy.baastion_policy.arn,
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
  ]
  max_session_duration = 3600
  name                 = "${var.stack}-ssm-ec2"
  path                 = "/"
  tags                 = {}
  tags_all             = {}

  inline_policy {}
}

resource "aws_iam_policy" "baastion_policy" {
  name   = "ssm-non-key"
  path   = "/"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ssm:StartSession",
            "Resource": [
                "arn:aws:ec2:*:*:instance/*",
                "arn:aws:ssm:*:*:document/AWS-StartSSHSession"
            ],
            "Condition": {
                "BoolIfExists": {
                    "ssm:SessionDocumentAccessCheck": "true"
                }
            }
        }
    ]
}
POLICY
  tags = {
    "Name" = "${var.stack}-bastion_policy"
  }
}

