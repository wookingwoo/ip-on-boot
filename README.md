# IP Notification on Boot

This service automatically sends the server's Internal and Public IP addresses to a specified Slack channel upon system boot.

## Prerequisites

- Ubuntu Server (or any systemd-based Linux distribution)
- `curl` installed (`sudo apt install curl`)
- A Slack Webhook URL

## Installation

1. **Clone or Copy files**:
   Place the files in a directory, for example: `/home/wookingwoo/ip-on-boot/`.

2. **Configure the Script**:
   Open `send_ip_to_slack.sh` and replace the placeholder URL with your actual Slack Webhook URL:
   ```bash
   SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
   ```

3. **Make the Script Executable**:
   ```bash
   chmod +x /home/wookingwoo/ip-on-boot/send_ip_to_slack.sh
   ```

4. **Install the Service**:
   Copy the service file to the systemd directory:
   ```bash
   sudo cp ip-on-boot.service /etc/systemd/system/
   ```

5. **Reload Systemd and Enable the Service**:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable ip-on-boot.service
   ```

## Usage

The service will run automatically on boot.

To manually test the service:
```bash
./send_ip_to_slack.sh
```

To manually start the service via systemd:
```bash
sudo systemctl start ip-on-boot.service
```

To check the status:
```bash
sudo systemctl status ip-on-boot.service
```
