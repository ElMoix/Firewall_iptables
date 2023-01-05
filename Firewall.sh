#!/bin/sh

# CHANGE HERE YOUR PUBLIC IP
PUBLICIP="X.X.X.X/32"
XLAN="192.168.1.0/24"
ETHWAN="enp1s0"
RASPI="192.168.1.200"

case "$1" in
  start)
        # Check for Root Privileges
	if ! [ $USER = 'root' ];then
		echo "This script must be executed as root.\n"
	else

	# Starting firewall
        echo "Executing Firewall Rules..."

        # Cleaning Firewall
        /sbin/iptables -F
        /sbin/iptables -X
        /sbin/iptables -Z
    	/sbin/iptables -t nat -F

        # Default Policy Firewall Rules
        /sbin/iptables -P INPUT ACCEPT
        /sbin/iptables -P OUTPUT ACCEPT
        /sbin/iptables -P FORWARD ACCEPT
        /sbin/iptables -t nat -P PREROUTING ACCEPT
        /sbin/iptables -t nat -P POSTROUTING ACCEPT

        # SSH
    	/sbin/iptables -A INPUT -p tcp -s $PUBLICIP --dport 22 -j ACCEPT
    	/sbin/iptables -A INPUT -p tcp -s $XLAN --dport 22 -j ACCEPT
    	/sbin/iptables -A INPUT -p tcp --dport 22 -j DROP

	# HTTP
	/sbin/iptables -A INPUT -p tcp -s $PUBLICIP --dport 80 -j ACCEPT
	/sbin/iptables -A INPUT -p tcp -s $XLAN --dport 80 -j ACCEPT
	/sbin/iptables -A INPUT -p tcp --dport 80 -j DROP

	# HTTPS
	/sbin/iptables -A INPUT -p tcp -s $PUBLICIP --dport 443 -j ACCEPT
	/sbin/iptables -A INPUT -p tcp -s $XLAN --dport 443 -j ACCEPT
	/sbin/iptables -A INPUT -p tcp --dport 443 -j DROP


	# Imagine 192.168.1.200 it's your RaspberryPI server
	# Port Forward 80
	/sbin/iptables -t nat -A PREROUTING -i $ETHWAN -s $PUBLICIP -p udp --dport 8080 -j DNAT --to-destination $RASPI:80
	# Port Forward 21
	/sbin/iptables -t nat -A PREROUTING -i $ETHWAN -s $PUBLICIP -p udp --dport 20:21 -j DNAT --to-destination $RASPI:20-21
	# Port Forward 22
	/sbin/iptables -t nat -A PREROUTING -i $ETHWAN -s $PUBLICIP -p udp --dport 2222 -j DNAT --to-destination $RASPI:80

	

	# SAVE IPTABLES PERSISTENT
	REQUIRED_PKG="iptables-persistent"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")
		echo "Checking package: $REQUIRED_PKG."
	if [ "" = "$PKG_OK" ]; then
		echo "$REQUIRED_PKG is not installed and must be. Now will be installed.\n"
  		sudo apt-get install $REQUIRED_PKG --yes
	fi
	iptables-save > /etc/iptables/rules.v4

	echo "\nOK. All done !!"
	echo "Check using: sudo iptables -nvL"
	fi
        ;;

  stop)
        # STOP Firewall
        /sbin/iptables -F
        /sbin/iptables -X
        /sbin/iptables -Z
    	/sbin/iptables -t nat -F
	
	echo "Firewall Stopped."
        ;;
  *)
        echo "Usage: ./Firewall.sh {start|stop}"
        exit 1
esac
exit 0
