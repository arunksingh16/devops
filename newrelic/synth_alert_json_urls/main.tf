# https://registry.terraform.io/providers/newrelic/newrelic/latest/docs
terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
      #version = "2.39.2"
    }
  }
}


provider "newrelic" {
  account_id = var.NEWRELIC_ACCOUNT_ID
  api_key    = var.NEWRELIC_API_KEY
  region     = var.NEWRELIC_REGION
}
