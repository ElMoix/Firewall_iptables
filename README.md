A basic firewall using iptables and filtering ssh (port 22).
You can modify this script to filter every port you want from any addresses.
These repo install the iptables-persistent to execute the firewall file when your server start

### BEFORE INSTALLATION:
Edit the file Firewall.sh and change the variable $PUBLICIP (XXX.XXX.XXX.XXX/32) with your public IP or DNS name. 

### INSTALLATION:
sudo chmod +x Firewall.sh

### USAGE:
sudo ./Firewall.sh start
When you proceed to execute the script, it will ask you to save the current ipv4 and ipv6 iptables rules into a specific path.
You simply accept saving the current ipv4 iptables rules selecting 'yes'.

**This script must be executed as root.**

### CHECK IF WORKED:
iptables -nvL or cat /etc/iptables/rules.v4
