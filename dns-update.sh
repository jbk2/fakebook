#!/bin/bash

DIR=`dirname "$(readlink -f "$0")"`
source $DIR/settings.sh

log() {
  local MESSAGE="$1"
  local TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
  logger -t update-dns "[$TIMESTAMP] $MESSAGE"
  echo "[$TIMESTAMP] $MESSAGE" 
}

log "Starting DNS update"

# Fetch IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
if [ -z "$TOKEN" ]; then
  log "Failed to get IMDSv2 token"
  exit 1
fi

# Get & set the instance's public IP address
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/public-ipv4)
if [ -z "$PUBLIC_IP" ]; then
  log "Failed to get public IP address"
  exit 1
fi
log "Retrieved public IP: $PUBLIC_IP"


# Parse DNS_RECORD_NAMESANDIDS and loop through it
echo "$DNS_RECORD_NAMESANDIDS" | jq -r 'to_entries[] | "\(.key) \(.value)"' | while read -r RECORD_NAME RECORD_ID; do
  # Create JSON payload for Cloudflare
  CHANGE_BATCH=$(cat <<EOF
{
  "type": "A",
  "name": "$RECORD_NAME",
  "content": "$PUBLIC_IP",
  "ttl": 300,
  "proxied": true
}
EOF
)

log "Updating DNS record for $RECORD_NAME"

 # Update Cloudflare DNS record
  RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
       -H "Authorization: Bearer $CF_API_TOKEN" \
       -H "Content-Type: application/json" \
       --data "$CHANGE_BATCH")

  HTTP_CODE=$(echo "$RESPONSE" | jq -r '.success')
  ERROR_MESSAGE=$(echo "$RESPONSE" | jq -r '.errors[0].message')
  if [ "$HTTP_CODE" != "true" ]; then
      if [ "$ERROR_MESSAGE" == "A record with the same settings already exists." ]; then
          log "DNS record for $RECORD_NAME is already up-to-date."
      else
          log "Failed to update DNS record for $RECORD_NAME. Response: $RESPONSE"
      fi
  else
      log "Successfully updated DNS record for $RECORD_NAME."
  fi
done

log "DNS update script completed."