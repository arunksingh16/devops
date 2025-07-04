variable "NEWRELIC_ACCOUNT_ID" {
  type        = number
  description = "New Relic Account ID"
}

variable "NEWRELIC_API_KEY" {
  type        = string
  description = "User API Key to connect New Relic Account"
}

variable "AWS_ACCNT_ID" {
  type        = string
  description = "AWS Account ID"
}

variable "AWS_REGION" {
  type        = string
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "PAGERDUTY_KEY" {
  type        = string
  description = "PD Integration key"
  default = "xx"
}

variable "NEWRELIC_REGION" {
  type        = string
  default     = "US"
  description = "New Relic Region for API calls"
}

variable "SERVICE_NAME" {
  type        = string
  description = "Name of Service(in short form)"
}

variable "ENV" {
  type    = string
  default = "prd"
}

variable "NR_API_IntegrationID" {
  type        = number
  description = "New Relic API Integration ID"
  default     = 111111
}

variable "NR_METRIC_IntegrationID" {
  type        = number
  description = "New Relic API Integration ID"
  default     = 111111
}

