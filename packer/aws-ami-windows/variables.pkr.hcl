variable "ami_prefix" {
  type        = string
  description = "Name of the AMI to be created"
  default     = "Windows-2022-English-Full"
}

variable "subnet_id" {
  type        = string
  description = "Subnet to launch temporary builder instance"
  default     = "subnet-xxxxx"
}

variable "security_group_id" {
  type        = string
  description = "Security group for builder instance"
  default     = "sg-xxxxx"
}

variable "winrm_password" {
  type =  string
  default = "<password>"
  sensitive = true
}

