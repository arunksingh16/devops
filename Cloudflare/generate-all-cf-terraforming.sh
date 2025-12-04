#!/usr/bin/env bash
# from  jrenggli/generate-all-cf-terraforming.sh
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-t CLOUDFLARE_API_TOKEN] [-a ACCOUNT_ID] [-z ZONE_ID]
Export Cloudflare resources to Terraform files using cf-terraforming.
Please ensure that you have the cf-terraforming tool installed
and an existing Terraform project with cloudflare/cloudflare provider configured.
Available options:
-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-t, --token     Cloudflare API token (or use CLOUDFLARE_API_TOKEN environment variable)
-a, --account   Cloudflare account ID
-z, --zone      Cloudflare zone ID
Exampless:
  $(basename "${BASH_SOURCE[0]}") -t <CLOUDFLARE_API_TOKEN> -a <ACCOUNT_ID> -z <ZONE_ID>
  $(basename "${BASH_SOURCE[0]}") -t <CLOUDFLARE_API_TOKEN> -a <ACCOUNT_ID>
  $(basename "${BASH_SOURCE[0]}") -t <CLOUDFLARE_API_TOKEN> -z <ZONE_ID>
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''
  account=''
  zone=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -t | --token) # Cloudflare API token
      CLOUDFLARE_API_TOKEN="${2-}"
      shift
      ;;
    -a | --account) # Cloudflare account ID
      account="${2-}"
      shift
      ;;
    -z | --zone) # Cloudflare zone ID
      zone="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  return 0
}

parse_params "$@"
setup_colors

# script logic here

if [[ -z "${CLOUDFLARE_API_TOKEN-}" ]]; then
  die "CLOUDFLARE_API_TOKEN is not set. Please export it before running this script. Or define it with -t or --token option."
fi

# All resource types to generate and import
# Extracted from https://github.com/cloudflare/cf-terraforming/blob/master/README.md
account_resource_types=(
  cloudflare_account
  cloudflare_account_member
  cloudflare_account_subscription
  cloudflare_address_map
  cloudflare_calls_sfu_app
  cloudflare_calls_turn_app
  cloudflare_d1_database
  cloudflare_dns_firewall
  cloudflare_dns_zone_transfers_acl
  cloudflare_dns_zone_transfers_peer
  cloudflare_dns_zone_transfers_tsig
  cloudflare_email_routing_address
  cloudflare_email_security_block_sender
  cloudflare_email_security_impersonation_registry
  cloudflare_email_security_trusted_domains
  cloudflare_list
  cloudflare_list_item
  cloudflare_load_balancer_monitor
  cloudflare_load_balancer_pool
  cloudflare_logpush_job
  cloudflare_magic_wan_static_route
  cloudflare_mtls_certificate
  cloudflare_notification_policy
  cloudflare_notification_policy_webhooks
  cloudflare_pages_domain
  cloudflare_pages_project
  cloudflare_queue
  cloudflare_queue_consumer
  cloudflare_r2_bucket
  cloudflare_r2_custom_domain
  cloudflare_r2_managed_domain
  cloudflare_registrar_domain
  cloudflare_ruleset
  cloudflare_stream
  cloudflare_stream_key
  cloudflare_stream_live_input
  cloudflare_stream_watermark
  cloudflare_stream_webhook
  cloudflare_turnstile_widget
  cloudflare_user
  cloudflare_workers_cron_trigger
  cloudflare_workers_custom_domain
  cloudflare_workers_deployment
  cloudflare_workers_for_platforms_dispatch_namespace
  cloudflare_workers_kv_namespace
  cloudflare_workers_script_subdomain
  cloudflare_zero_trust_access_application
  cloudflare_zero_trust_access_custom_page
  cloudflare_zero_trust_access_group
  cloudflare_zero_trust_access_identity_provider
  cloudflare_zero_trust_access_infrastructure_target
  cloudflare_zero_trust_access_key_configuration
  cloudflare_zero_trust_access_policy
  cloudflare_zero_trust_access_service_token
  cloudflare_zero_trust_access_short_lived_certificate
  cloudflare_zero_trust_access_tag
  cloudflare_zero_trust_device_custom_profile
  cloudflare_zero_trust_device_default_profile
  cloudflare_zero_trust_device_default_profile_local_domain_fallback
  cloudflare_zero_trust_device_managed_networks
  cloudflare_zero_trust_device_posture_integration
  cloudflare_zero_trust_device_posture_rule
  cloudflare_zero_trust_dex_test
  cloudflare_zero_trust_dlp_custom_profile
  cloudflare_zero_trust_dlp_dataset
  cloudflare_zero_trust_dlp_predefined_profile
  cloudflare_zero_trust_dns_location
  cloudflare_zero_trust_gateway_certificate
  cloudflare_zero_trust_gateway_policy
  cloudflare_zero_trust_gateway_proxy_endpoint
  cloudflare_zero_trust_gateway_settings
  cloudflare_zero_trust_list
  cloudflare_zero_trust_organization
  cloudflare_zero_trust_risk_behavior
  cloudflare_zero_trust_risk_scoring_integration
  cloudflare_zero_trust_tunnel_cloudflared
  cloudflare_zero_trust_tunnel_cloudflared_config
  cloudflare_zero_trust_tunnel_cloudflared_route
  cloudflare_zero_trust_tunnel_cloudflared_virtual_network
  cloudflare_web_analytics_rule
  cloudflare_web_analytics_site
)

zone_resource_types=(
  cloudflare_api_shield_discovery_operation
  cloudflare_api_shield_operation
  cloudflare_api_shield_operation_schema_validation_settings
  cloudflare_api_shield_schema
  cloudflare_api_shield_schema_validation_settings
  cloudflare_argo_smart_routing
  cloudflare_argo_tiered_caching
  cloudflare_authenticated_origin_pulls
  cloudflare_authenticated_origin_pulls_certificate
  cloudflare_bot_management
  cloudflare_certificate_pack
  cloudflare_content_scanning_expression
  cloudflare_custom_hostname
  cloudflare_custom_hostname_fallback_origin
  cloudflare_dns_record
  cloudflare_dns_zone_transfers_incoming
  cloudflare_dns_zone_transfers_outgoing
  cloudflare_email_routing_catch_all
  cloudflare_email_routing_dns
  cloudflare_email_routing_rule
  cloudflare_email_routing_settings
  cloudflare_filter
  cloudflare_healthcheck
  cloudflare_hostname_tls_setting
  cloudflare_keyless_certificate
  cloudflare_leaked_credential_check
  cloudflare_leaked_credential_check_rule
  cloudflare_load_balancer
  cloudflare_logpull_retention
  cloudflare_logpush_job
  cloudflare_managed_transforms
  cloudflare_notification_policy
  cloudflare_observatory_scheduled_test
  cloudflare_origin_ca_certificate
  cloudflare_page_rule
  cloudflare_page_shield_policy
  cloudflare_rate_limit
  cloudflare_regional_hostname
  cloudflare_regional_tiered_cache
  cloudflare_ruleset
  cloudflare_snippet_rules
  cloudflare_snippets
  cloudflare_spectrum_application
  cloudflare_tiered_cache
  cloudflare_total_tls
  cloudflare_url_normalization_settings
  cloudflare_waiting_room
  cloudflare_waiting_room_event
  cloudflare_waiting_room_rules
  cloudflare_waiting_room_settings
  cloudflare_web3_hostname
  cloudflare_zero_trust_access_application
  cloudflare_zero_trust_access_group
  cloudflare_zero_trust_access_identity_provider
  cloudflare_zero_trust_access_mtls_certificate
  cloudflare_zero_trust_access_mtls_hostname_settings
  cloudflare_zero_trust_access_service_token
  cloudflare_zero_trust_access_short_lived_certificate
  cloudflare_zero_trust_device_default_profile_certificates
  cloudflare_zero_trust_organization
  cloudflare_zone
  cloudflare_zone_cache_reserve
  cloudflare_zone_cache_variants
  cloudflare_zone_dnssec
  cloudflare_zone_lockdown
  cloudflare_zone_setting
)

if [[ -n "${account-}" ]]; then
  msg "${GREEN}Using Cloudflare account ID: ${account}${NOFORMAT}"

  folder="generate/cloudflare/account/${account}/"
  mkdir -p ${folder}

  for resource_type in "${account_resource_types[@]}"; do
    msg "${GREEN}Generating resources for account: ${account}, resource type: ${resource_type}${NOFORMAT}"
    cf-terraforming generate \
      --account ${account} \
      --resource-type "$resource_type" > "${folder}${resource_type}.account.tf" || msg "${RED}Failed to generate ${resource_type} for account ${account}${NOFORMAT}"
    cf-terraforming import \
      --modern-import-block \
      --account ${account} \
      --resource-type "$resource_type" > "${folder}${resource_type}.account.import.tf" || msg "${RED}Failed to import ${resource_type} for account ${account}${NOFORMAT}"
  done

  msg "${GREEN}Resources generated and imported for account: ${account}${NOFORMAT}"
fi

if [[ -n "${zone-}" ]]; then
  msg "${GREEN}Using Cloudflare zone ID: ${zone}${NOFORMAT}"

  folder="generate/cloudflare/zone/${zone}/"
  mkdir -p ${folder}

  for resource_type in "${zone_resource_types[@]}"; do
    msg "${GREEN}Generating resources for zone: ${zone}, resource type: ${resource_type}${NOFORMAT}"
    cf-terraforming generate \
      --zone ${zone} \
      --resource-type "$resource_type" > "${folder}${resource_type}.zone.tf" || msg "${RED}Failed to generate ${resource_type} for zone ${zone}${NOFORMAT}"
    cf-terraforming import \
      --modern-import-block \
      --zone ${zone} \
      --resource-type "$resource_type" > "${folder}${resource_type}.zone.import.tf" || msg "${RED}Failed to import ${resource_type} for zone ${zone}${NOFORMAT}"
  done

  msg "${GREEN}Resources generated and imported for zone: ${zone}${NOFORMAT}"
fi
