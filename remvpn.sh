#!/bin/bash
vpndir=/home/administrator/VPN
easyrsa=EasyRSA-3.0.8
if readlink /proc/$$/exe | grep -qs "dash"; then
	echo "This script needs to be run with bash, not sh! Bash it real good!"
	exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root, what is wrong with you?"
	exit 2
fi
if [ "$1" = "list" ]; then
	echo "A list of users:"
	ls $vpndir/client-configs/files/
	exit
fi
if [ "$1" = "" ]; then
	echo "to get a list of current users: sudo ./remvpn.sh list"
	echo "remove user exactly as you see it, one word, no spaces!"
	echo "Eg: sudo ./remvpn.sh Bob_Builder"
	exit
else
	cd $vpndir/$easyrsa/
	./easyrsa revoke $1
	# Deletes the bad hombre, bigly!
	./easyrsa gen-crl
	rm $vpndir/client-configs/files/$1.ovpn
	rm $vpndir/client-configs/keys/$1.crt
	rm $vpndir/client-configs/keys/$1.key
        #copies the gfy key to ovpn
        mv /etc/openvpn/crl.pem /etc/openvpn/crl.pem.bk
        mv $vpndir/$easyrsa/pki/crl.pem /etc/openvpn/
	cd ~
	echo ""
	echo "Client $1 deleted!"
	systemctl restart openvpn@server
fi
