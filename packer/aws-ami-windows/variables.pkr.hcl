variable "aws_region" {
  type        = string
  description = "AWS region to build AMI in"
  default     = "eu-west-1"
}

variable "skip_ami" {
  type        = bool
  default     = false
  description = "Skip AMI creation, useful for debugging"
}

variable "ami_prefix" {
  type        = string
  description = "Name of the AMI to be created"
  default     = "windows-2022-English-Full"
}

variable "subnet_id" {
  type        = string
  description = "Subnet to launch temporary builder instance"
  default     = "subnet-xxx"
}

# The security group must allow inbound traffic on port 5985, 5986 for WinRM.

variable "security_group_id" {
  type        = string
  description = "Security group for builder instance"
  default     = "sg-xxx"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}


variable "winrm_password" {
  type      = string
  sensitive = true
}

