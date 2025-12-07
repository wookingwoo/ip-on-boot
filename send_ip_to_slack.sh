#!/bin/bash

# Configuration
# Load configuration from config.env
CONFIG_FILE="$(dirname "$0")/config.env"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: config.env not found!"
    exit 1
fi

# Check if URL is set
if [ -z "$SLACK_WEBHOOK_URL" ]; then
    echo "Error: SLACK_WEBHOOK_URL is not set in config.env"
    exit 1
fi

# Function to get Internal IP
get_internal_ip() {
    # Try hostname -I
    IP=$(hostname -I 2>/dev/null | awk '{print $1}')
    if [ -n "$IP" ]; then echo "$IP"; return; fi

    # Try ip route
    IP=$(ip route get 1 2>/dev/null | awk '{print $7; exit}')
    if [ -n "$IP" ]; then echo "$IP"; return; fi

    # Try python3
    if command -v python3 >/dev/null 2>&1; then
        IP=$(python3 -c 'import socket; s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(("8.8.8.8", 80)); print(s.getsockname()[0]); s.close()' 2>/dev/null)
        if [ -n "$IP" ]; then echo "$IP"; return; fi
    fi

    echo "Unknown (Check network tools)"
}

# Function to get Public IP
get_public_ip() {
    curl -s ifconfig.me
}

# Main Logic
INTERNAL_IP=$(get_internal_ip)
PUBLIC_IP=$(get_public_ip)
HOSTNAME=$(hostname)
DATE=$(date)

# Construct Message
MESSAGE="*Server Booted!* :rocket:\n\n*Details:*\n- *Hostname:* $HOSTNAME\n- *Time:* $DATE\n- *Internal IP:* $INTERNAL_IP\n- *Public IP:* $PUBLIC_IP"

# Send to Slack
payload="payload={\"text\": \"$MESSAGE\"}"

# Use curl to send the post request
curl -s -X POST --data-urlencode "$payload" "$SLACK_WEBHOOK_URL"

echo "Notification sent to Slack."
