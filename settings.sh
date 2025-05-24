#!/usr/bin/env bash
set -euo pipefail

# Load environment variables
# Determine the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Try local .env first (for local execution), then remote (for EC2 context)
if [ -f "$DIR/.env" ]; then
  echo "Loading local .env from $DIR/.env"
  set -o allexport
  source "$DIR/.env"
  set +o allexport
elif [ -f "/home/ubuntu/.env" ]; then
  echo "Loading remote .env from /home/ubuntu/.env"
  set -o allexport
  source "/home/ubuntu/.env"
  set +o allexport
else
  echo "No .env file found locally or in /home/ubuntu/.env"
  exit 1
fi

# ----------------------------------------

INFO="\033[0;32m"  # Green
SUCCESS="\033[1;32m"  # Green bold
ALERT="\033[0;34m"    # Blue
WARNING="\033[0;33m"  # Yellow
ERROR="\033[0;31m"    # Red
NC="\033[0m"          # No color

# ----------------------------------------

# SSH related variables

SSH_OPTIONS=${SSH_OPTIONS:-"-i $SSH_KEY -o StrictHostKeyChecking=no"}
UBUNTU_SSH_ARGS="ubuntu@$SERVER -p $SSH_PORT $SSH_OPTIONS"
APP_SSH_ARGS="$USER@$SERVER -p $SSH_PORT $SSH_OPTIONS"

# ----------------------------------------

ssh_as_ubuntu() {
  ssh $UBUNTU_SSH_ARGS $@
}
# Must pass in USER variable, otherwise defaults to ubuntu
ssh_as_user() {
  ssh $APP_SSH_ARGS $@
}