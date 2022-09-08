#!/bin/sh
### BEGIN INIT INFO
# Provides:          firewall
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Enabling firewall
# Description:       Enabling firewall
### END INIT INFO
#set -e

# CHANGE HERE YOUR PUBLIC IP
PUBLICIP="XXX.XXX.XXX.XXX/32"
XLAN="192.168.1.0/24"

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

        # Default Firewall Rules
        /sbin/iptables -P INPUT ACCEPT
        /sbin/iptables -P OUTPUT ACCEPT
        /sbin/iptables -P FORWARD ACCEPT
        /sbin/iptables -t nat -P PREROUTING ACCEPT
        /sbin/iptables -t nat -P POSTROUTING ACCEPT

        # SSH
    	#/sbin/iptables -A INPUT -p tcp -s $PUBLICIP --dport 22 -j ACCEPT
    	/sbin/iptables -A INPUT -p tcp -s $XLAN --dport 22 -j ACCEPT
    	/sbin/iptables -A INPUT -p tcp --dport 22 -j DROP

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
	echo "Check using: sudo iptables -nvL -t filter"
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
