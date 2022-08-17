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

PUBLICIP="XXX.XXX.XXX.XXX/32"
PUBLICIP2="XXX.XXX.XXX.XXX/32"
XLAN="192.168.1.0/24"

case "$1" in
  start)
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
    	/sbin/iptables -A INPUT -p tcp -s $PUBLICIP --dport 22 -j ACCEPT
    	/sbin/iptables -A INPUT -p tcp -s $PUBLICIP2 --dport 22 -j ACCEPT
    	/sbin/iptables -A INPUT -p tcp -s $XLAN --dport 22 -j ACCEPT
    	/sbin/iptables -A INPUT -p tcp --dport 22 -j DROP

	# SAVE IPTABLES IN PERSISTENT
	iptables-save > /etc/iptables/rules.v4

	echo "OK. All done !!"
        ;;

  stop)
        # STOP Firewall
        /sbin/iptables -F
        /sbin/iptables -X
        /sbin/iptables -Z
    	/sbin/iptables -t nat -F
	
	echo "Stopping Firewall."
        ;;
  *)
        echo "Usage: /etc/init.d/firewall {start|stop}"
        exit 1
esac
exit 0
