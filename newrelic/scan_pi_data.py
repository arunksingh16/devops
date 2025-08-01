import requests
import re
import json

# --------- CONFIGURATION ---------
API_KEY = "xx-xx"
ACCOUNT_ID = "12345"
NRQL_QUERY = 'SELECT message FROM Log SINCE 30 minutes ago LIMIT 1000'
NERDGRAPH_ENDPOINT = "https://api.newrelic.com/graphql"

# --------- PII DETECTION REGEX ---------
PII_PATTERNS = {
    "email": re.compile(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),
    "phone": re.compile(r'\b(?:\+?1[-.\s]?)?\(?([0-9]{3})\)?[-.\s]?([0-9]{3})[-.\s]?([0-9]{4})\b'),
    "credit_card": re.compile(r'\b(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|3[0-9]{13}|6(?:011|5[0-9]{2})[0-9]{12})\b'),
    "ssn": re.compile(r'\b\d{3}-\d{2}-\d{4}\b'),
    "ip_address": re.compile(r'\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'),
    "mac_address": re.compile(r'\b([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})\b'),
}

def get_account_details(account_id):
    """Fetch account details from New Relic API"""
    headers = {
        "API-Key": API_KEY,
        "Content-Type": "application/json"
    }
    graphql_query = {
        "query": f"""
        {{
          actor {{
            account(id: {account_id}) {{
              id
              name
              region
            }}
          }}
        }}
        """
    }
    try:
        response = requests.post(NERDGRAPH_ENDPOINT, headers=headers, json=graphql_query)
        response.raise_for_status()
        data = response.json()
        return data['data']['actor']['account']
    except Exception as e:
        print(f"Warning: Could not fetch account details: {e}")
        return None

def run_nerdgraph_query(account_id, query):
    headers = {
        "API-Key": API_KEY,
        "Content-Type": "application/json"
    }
    graphql_query = {
        "query": f"""
        {{
          actor {{
            account(id: {account_id}) {{
              nrql(query: "{query}") {{
                results
              }}
            }}
          }}
        }}
        """
    }
    response = requests.post(NERDGRAPH_ENDPOINT, headers=headers, json=graphql_query)
    response.raise_for_status()
    return response.json()

def scan_for_pii(log_msg):
    # Simple filtering to avoid obvious system patterns
    system_indicators = [
        'UID ', 'systemd[', 'kernel:', 'audit:', 'profile=', 'operation=', 
        'comm=', 'fsuid=', 'ouid=', '/proc/', '/run/user/'
    ]
    
    # Skip if message contains obvious system indicators
    if any(indicator in log_msg for indicator in system_indicators):
        return {}
    
    results = {}
    for label, pattern in PII_PATTERNS.items():
        matches = pattern.findall(log_msg)
        if matches:
            # For phone numbers, filter out very long numbers that are likely UIDs
            if label == "phone":
                filtered_matches = []
                for match in matches:
                    if isinstance(match, tuple):
                        match = ''.join(match)
                    # Only include if it's a reasonable phone number length
                    clean_match = match.replace('-', '').replace('.', '').replace(' ', '').replace('(', '').replace(')', '')
                    if 10 <= len(clean_match) <= 15:  # Reasonable phone number length
                        filtered_matches.append(match)
                if filtered_matches:
                    results[label] = filtered_matches
            else:
                results[label] = matches
    return results

def main():
    print("=== New Relic PII Data Finder ===\n")
    
    # Display account information
    print("Account Details:")
    account_info = get_account_details(ACCOUNT_ID)
    if account_info:
        print(f"  Account ID: {account_info['id']}")
        print(f"  Account Name: {account_info['name']}")
        print(f"  Region: {account_info['region']}")
    else:
        print(f"  Account ID: {ACCOUNT_ID}")
    print()
    
    print("Running NRQL log query...")
    data = run_nerdgraph_query(ACCOUNT_ID, NRQL_QUERY)
    log_results = data['data']['actor']['account']['nrql']['results']

    print(f"Scanning {len(log_results)} log entries for potential PII...\n")
    for entry in log_results:
        message = entry.get("message", "")
        findings = scan_for_pii(message)
        if findings:
            print(f"[PII DETECTED] {json.dumps(findings)}")
            print(f"  >> {message}\n")

if __name__ == "__main__":
    main()
