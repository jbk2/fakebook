#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------

INFO="\033[0;32m"  # Green
SUCCESS="\033[1;32m"  # Green bold
ALERT="\033[0;34m"    # Blue
WARNING="\033[0;33m"  # Yellow
ERROR="\033[0;31m"    # Red
NC="\033[0m"          # No color

# ----------------------------------------

# Provisioning, admin & SSH related variables
USER=${USER:-ubuntu}
SERVER=${SERVER:-51.44.24.22}
SERVER_NAME=${SERVER_NAME:-www.fakebook.bibble.com}
PORT=${PORT:-22} # the default ssh port
SSH_KEY=${SSH_KEY:-~/Documents/Code/Credentials/fakebook-ec2-keypair.pem}
SSH_OPTIONS=${SSH_OPTIONS:-"-i $SSH_KEY -o StrictHostKeyChecking=no"}
UBUNTU_SSH_ARGS="ubuntu@$SERVER -p $PORT $SSH_OPTIONS"
APP_SSH_ARGS="$USER@$SERVER -p $PORT $SSH_OPTIONS"

# ----------------------------------------

# DNS related variables
CF_API_TOKEN="68K1XhBdJzlRj9nY0ffB-BFaaHZHihBUqqxLlaBR"
ZONE_ID="285b023e745e3469b488c1101adfcef8"
RECORD_ID1="7082251d9ea4d4735341776c1db70cca"  # Record ID for fakebook.bibble.com
RECORD_NAME1="fakebook.bibble.com"
RECORD_ID2="2229ae7285755aadfb56117d5d50b748"  # Record ID for www.fakebook.bibble.com
RECORD_NAME2="www.fakebook.bibble.com"

# ----------------------------------------

ssh_as_ubuntu() {
  ssh $UBUNTU_SSH_ARGS $@
}
# Must pass in USER variable, otherwise defaults to ubuntu
ssh_as_user() {
  ssh $APP_SSH_ARGS $@
}