# Firewall Script
A basic firewall using iptables and iptables-persistent.
You can modify this script to filter every port you want from any addresses.
These repo install the iptables-persistent to execute the firewall file when your server start.
This script is focused for linux-based OS.
The Default Policy for Iptables is "Accept". If you have to open some ports, you can specify the source address.

### BEFORE INSTALLATION:

Edit the file Firewall.sh and change the variable **$PUBLICIP** (X.X.X.X/32) with your public IP or DDNS. 

### Ports
It opens port 22 (ssh), port 80 (http) and port 443 (https).
Also does a redirection to a specific server (example: RaspberryPI with IP 192.168.1.200) with ports 80,21 and 22.

### USAGE:

    sudo ./Firewall.sh {start/stop} 

When you proceed to execute the script, it will ask you to save the current ipv4 and ipv6 iptables rules into a specific path.
You simply accept saving the current ipv4 iptables rules selecting **'yes'**.

### **This script must be executed as root.**

### CHECK IF WORKED:

    iptables -nvL
    or
    cat /etc/iptables/rules.v4