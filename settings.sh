#!/usr/bin/env bash
set -euo pipefail

# Load environment variables
ENV_PATH="/home/ubuntu/.env"

echo "Attempting to load .env from $ENV_PATH"
if [ -f "$ENV_PATH" ]; then
  set -o allexport
  source "$ENV_PATH"
  set +o allexport
else
    echo ".env file not found in $ENV_PATH"
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