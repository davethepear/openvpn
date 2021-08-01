#!/bin/bash
# Put your VPN files directory here, without closing slash /. I recommend one like the one below.
# the client-configs directory should be within this directory!
vpndir=/home/user/VPN
email=user@email.com

# EasyRSA Version - It will be the same as the directory, no /. I hope it's in the vpn directory!
easyrsa=EasyRSA-3.0.8

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
        ls $vpndir/client-configs/files/
        exit
fi
if [ "$1" = "" ]; then
        echo "to get a list of current users: sudo ./addvpn.sh list"
        echo "Add user as one word, no spaces!"
        echo "Eg: sudo ./addvpn.sh Bob_Builder bob@email.com"
        echo "No emailing? sudo ./addvpn.sh BobTheBuilder or sudo ./addvpn.sh Bob_Builder none"
        exit
fi
if [ "$2" = "" ]; then
        echo "The client email address? If no emailing: sudo ./addvpn.sh Bob_Builder none"
        echo "Add user as one word, no spaces!"
        echo "Eg: sudo ./addvpn.sh Bob_Builder bob@email.com"
        exit

else
        cd $vpndir/$easyrsa/
        ./easyrsa build-client-full $1 nopass
        # Generates the custom client.ovpn
        cp $vpndir/client-common.txt $vpndir/client-configs/files/$1.ovpn
        echo "<ca>" >> $vpndir/client-configs/files/$1.ovpn
        cat $vpndir/$easyrsa/pki/ca.crt >> $vpndir/client-configs/files/$1.ovpn
        echo "</ca>" >> $vpndir/client-configs/files/$1.ovpn
        echo "<cert>" >> $vpndir/client-configs/files/$1.ovpn
        cat $vpndir/$easyrsa/pki/issued/$1.crt >> $vpndir/client-configs/files/$1.ovpn
        echo "</cert>" >> $vpndir/client-configs/files/$1.ovpn
        echo "<key>" >> $vpndir/client-configs/files/$1.ovpn
        cat $vpndir/$easyrsa/pki/private/$1.key >> $vpndir/client-configs/files/$1.ovpn
        echo "</key>" >> $vpndir/client-configs/files/$1.ovpn
        echo "<tls-auth>" >> $vpndir/client-configs/files/$1.ovpn
        cat $vpndir/$easyrsa/ta.key >> $vpndir/client-configs/files/$1.ovpn
        echo "</tls-auth>" >> $vpndir/client-configs/files/$1.ovpn
        cd $vpndir/
        # you could use this, but why? chown nobody:nogroup $vpndir/client-configs/files/*.ovpn
        cd $vpndir/
        echo ""
fi
if [ "$2" = "none" ]; then
        echo "Client $1 added, configuration is available here: $vpndir/client-configs/files/$1.ovpn"
        else
        echo "Client $1 added, emailing client files, configuration is available at" $vpndir/client-configs/files/$1.ovpn"
        mutt -s "VPN for $1" -a "$vpndir/client-configs/files/$1.ovpn" -c $2 -b $email < $vpndir/vpn-message.txt
fi
