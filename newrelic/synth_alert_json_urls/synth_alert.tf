
locals {
  all_urls = jsondecode(file("${path.module}/monitoring.json"))
  keepalive_urls = [
    for obj in local.all_urls : obj
    if can(regex("^https://[^/]+/[^/]+/?$", obj.url))
  ]
}


resource "newrelic_synthetics_monitor" "monitor_number" {
  for_each = { for url_obj in local.keepalive_urls : url_obj.url => url_obj }

  name = substr(
    replace(
      replace(each.value.url, "https?://", ""),
      "[^a-zA-Z0-9]", "-"
    ),
    0,
    64
  )
  uri              = each.value.url
  type             = "SIMPLE"
  status           = "ENABLED"
  period           = "EVERY_15_MINUTES"
  locations_public = ["EU_CENTRAL_1"]
  treat_redirect_as_failure = true
  validation_string         = ""
  bypass_head_request       = true
  verify_ssl                = false

  tag {
    key    = "IaC"
    values = ["Terraform"]
  }
  tag {
    key    = "Environment"
    values = ["Production"]
  }
}

resource "newrelic_alert_policy" "Synthetic_Monitoring_number" {
  name                = "${var.ENV}-${var.SERVICE_NAME}: Synthetic Monitoring Number URLs"
  incident_preference = "PER_CONDITION"
}

resource "newrelic_nrql_alert_condition" "web_server_keepalive" {
  for_each  = newrelic_synthetics_monitor.monitor_number

  account_id = var.NEWRELIC_ACCOUNT_ID
  policy_id  = newrelic_alert_policy.Synthetic_Monitoring_number.id
  type       = "static"
  name       = each.value.name
  enabled    = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') FROM SyntheticCheck WHERE NOT isMuted AND entityGuid IN ('${each.value.id}') FACET entityGuid, location"
  }

  critical {
    operator              = "above_or_equals"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
  fill_option           = "none"
  aggregation_window    = 60
  aggregation_method    = "event_flow"
  aggregation_delay     = 300
}
