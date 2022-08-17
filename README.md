A basic firewall using iptables and filtering ssh (port 22).
You can modify this script to filter every port you want from any addresses.
These repo install the iptables-persistent to execute the firewall file when your server start

You have to:

  sudo apt-get update && apt-get install iptables-persistent -y

Then you have to give execution permissions to the file:
sudo chmod +x Firewall.sh

Finally, change the IP (XXX.XXX.XXX.XXX/32) with your static public IP.
You can set a dns name too.
