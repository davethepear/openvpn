#!/bin/bash

if readlink /proc/$$/exe | grep -qs "dash"; then
	echo "This script needs to be run with bash, not sh! Bash it good!"
	exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root, what's wrong with you?"
	exit 2
fi
if [ "$1" = "list" ]; then
        echo "A list of users:"
        ls /home/administrator/VPN/client-configs/files/
        exit
fi
if [ "$1" = "" ]; then
        echo "to get a list of current users: sudo ./addvpn.sh list"
	echo "Add user as one word, no spaces!"
	echo "Eg: sudo ./addvpn.sh BobTheBuilder or sudo ./addvpn.sh Bob_Builder bob@email.com"
	exit
if [ "$2" = "" ]; then
	echo "Their email address? If none, just type your own, it has to be valid!"
        echo "Add user as one word, no spaces!"
        echo "Eg: sudo ./addvpn.sh Bob_Builder bob@email.com"
	exit
fi

else
	cd /home/administrator/VPN/EasyRSA-3.0.8/ #Update this some fine day
	./easyrsa build-client-full $1 nopass
	# Generates the custom client.ovpn
	cp /home/administrator/VPN/client-configs/client-common.txt /home/administrator/VPN/client-configs/files/$1.ovpn
	echo "<ca>" >> /home/administrator/VPN/client-configs/files/$1.ovpn
	cat /home/administrator/VPN/EasyRSA-3.0.8/pki/ca.crt >> /home/administrator/VPN/client-configs/files/$1.ovpn
	echo "</ca>" >> /home/administrator/VPN/client-configs/files/$1.ovpn
	echo "<cert>" >> /home/administrator/VPN/client-configs/files/$1.ovpn
	cat /home/administrator/VPN/EasyRSA-3.0.8/pki/issued/$1.crt >> /home/administrator/VPN/client-configs/files/$1.ovpn
	echo "</cert>" >> /home/administrator/VPN/client-configs/files/$1.ovpn
	echo "<key>" >> /home/administrator/VPN/client-configs/files/$1.ovpn
	cat /home/administrator/VPN/EasyRSA-3.0.8/pki/private/$1.key >> /home/administrator/VPN/client-configs/files/$1.ovpn
	echo "</key>" >> /home/administrator/VPN/client-configs/files/$1.ovpn
	echo "<tls-auth>" >> /home/administrator/VPN/client-configs/files/$1.ovpn
	cat /home/administrator/VPN/EasyRSA-3.0.8/ta.key >> /home/administrator/VPN/client-configs/files/$1.ovpn
	echo "</tls-auth>" >> /home/administrator/VPN/client-configs/files/$1.ovpn
	cd /home/administrator/VPN/
	# you could use this, but why? chown nobody:nogroup /home/administrator/VPN/client-configs/files/*.ovpn
	cd /home/administrator
	echo ""
	echo "Client $1 added, emailing client files, configuration is available at" /home/administrator/VPN/client-configs/files/"$1.ovpn"
        mutt -s "VPN for $1" -a "/home/administrator/VPN/client-configs/files/$1.ovpn" -c $2 -b administrator < /home/administrator/VPN/vpn-message.txt
fi
