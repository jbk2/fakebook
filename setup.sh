#!/usr/bin/env bash
set -euo pipefail

DIR=`dirname "$(readlink -f "$0")"`
source $DIR/settings.sh
SCP_ARGS="-i $SSH_KEY"

# ----------------------------------------

INFO="\033[0;32m"     # Green
SUCCESS="\033[1;32m"  # Green bold
ALERT="\033[0;34m"    # Blue
WARNING="\033[0;33m"  # Yellow
ERROR="\033[0;31m"    # Red
NC="\033[0m"          # No color

# ----------------------------------------

USAGE="
##################################
Usage:
  $0
  $0 -u UNIT -s STEP

Options:
  -u UNIT    run only a given unit ("dns_auto_update", "update_upgrade"). If no step is specified, all steps in the unit will run.
  -s STEP    run only a given step ("upload_dns_script", "create_dns_update_service", "update", "upgrade")
  -v         run in verbose mode
  -h         show this help message
##################################
"

# ----------------------------------------

RUN_UNIT=""
RUN_STEP=""
VERBOSE=false

# each UNIT or STEP value must be defined in the corresponding array
# to enabling correct parsing of command line arguments:
valid_units=("dns_auto_update" "update_upgrade")
valid_steps=("upload_dns_script" "create_dns_update_service" "update" "upgrade")

function contains_element {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

while getopts ":u:s:vh" opt; do
  case $opt in
    u)
      if contains_element "$OPTARG" "${valid_units[@]}"; then
        RUN_UNIT=$OPTARG
      else
        echo -e "${ERROR}Invalid unit specified: $OPTARG. Valid units are: ${valid_units[*]}.${NC}"
        echo -e "$USAGE"
        exit 1
      fi
      ;;
    s)
      if contains_element "$OPTARG" "${valid_steps[@]}"; then
        RUN_STEP=$OPTARG
      else
        echo -e "${ERROR}Invalid step specified: $OPTARG. Valid steps are: ${valid_steps[*]}.${NC}"
        echo -e "$USAGE"
        exit 1
      fi
      ;;
    v)
      VERBOSE=true;;
    h)
      echo -e "$USAGE"
      exit 0;;
    \?)
      echo -e "${ERROR}$OPTARG is not a valid option.${NC}"
      echo -e "$USAGE"
      exit 1;;
  esac
done

# ----------------------------------------

if [ "$VERBOSE" = "true" ]; then
  set -x  # Enable debugging output
fi

should_run() {
  # No unit and no step specified
  if [ -z "$RUN_UNIT" ] && [ -z "$RUN_STEP" ]; then
    return 0  # True, run all
  fi

  # Specific unit, no step specified
  if [ "$RUN_UNIT" = "$UNIT" ] && [ -z "$RUN_STEP" ]; then
    return 0  # True, run all steps in the specified unit
  fi

  # No unit, specific step specified
  if [ -z "$RUN_UNIT" ] && [ "$RUN_STEP" = "$STEP" ]; then
    return 0  # True, run the specified step in all units
  fi

  # Specific unit and specific step specified
  if [ "$RUN_UNIT" = "$UNIT" ] && [ "$RUN_STEP" = "$STEP" ]; then
    return 0  # True, run the specified step in the specified unit
  fi

  return 1  # False, do not run
}

# ----------------------------------------

UNIT=dns_auto_update
STEP=upload_dns_script

if should_run; then
echo -e "${INFO}Transferring dns-update.sh to server...${NC}"

if scp $SCP_ARGS $DIR/dns-update.sh ubuntu@$SERVER:~/dns-update.sh
then
  echo -e "${SUCCESS}successfully scp'd dns-update.sh to ~/dns-update.sh on $SERVER${NC}"
else
  echo -e "${ERROR}failed to scp dns-update.sh to ~/dns-update.sh on $SERVER${NC}"
  exit 1
fi

if ssh_as_ubuntu "sudo mv ~/dns-update.sh /usr/local/bin/dns-update.sh && sudo chmod +x /usr/local/bin/dns-update.sh"
then
  echo -e "${SUCCESS}successfully mv'd ~/dns-update.sh to /usr/local/bin/dns-update.sh on $SERVER & chmod'd +x.${NC}"
else
  echo -e "${ERROR}failed to mv ~/dns-update.sh to /usr/local/bin/dns-update.sh on $SERVER & chmod +x.${NC}"
  exit 1
fi

STEP=create_dns_update_service
ssh_as_ubuntu <<-STDIN || echo -e "${ERROR}Creating systemd unit file for dns-update.sh${NC}"
  echo -e "${INFO}Creating systemd unit file for dns-update.sh...${NC}"

  # Create the service unit file
  cat <<EOF | sudo tee /etc/systemd/system/dns-update.service > /dev/null
[Unit]
Description=Update DNS with instance public IP
After=network.target

[Service]
ExecStart=/usr/local/bin/dns-update.sh
StandardOutput=append:/var/log/dns-update.log
StandardError=append:/var/log/dns-update.log
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

  # Reload systemd and enable the service
  sudo systemctl daemon-reload
  sudo systemctl enable dns-update.service
  sudo systemctl start dns-update.service
  
  echo -e "${SUCCESS}Systemd service created and started successfully.${NC}"
STDIN
fi

# ----------------------------------------

UNIT=update_upgrade
STEP=update
if should_run; then
ssh_as_ubuntu <<-STDIN || echo -e "${ERROR}Updating packages${NC}"
  sudo apt update -y && echo -e "${SUCCESS}successfully updated packages${NC}" || echo -e "${ERROR}failed to update packages${NC}"
STDIN
fi

STEP=upgrade
if should_run; then
ssh_as_ubuntu <<-STDIN || echo -e "${ERROR}Ugrading packages${NC}"
  sudo apt upgrade -y && echo -e "${SUCCESS}successfully upgraded packages${NC}" || echo -e "${ERROR}failed to upgrade packages${NC}"
STDIN
fi

# ----------------------------------------