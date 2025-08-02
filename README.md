I've gotten lazy and https://github.com/Nyr/openvpn-install is much better...

# Add &amp; Remove OpenVPN Users with Ease

## Programs needed
- OpenVPN Server
- EasyRSA
- mutt (if you want to use email functionality)
- postfix (if you want the email functionality to work)

Instructions on installing OpenVPN and Clients: http://www.linncountykansas.com/install_openvpn_server.html

## Editing
- Edit `addvpn.sh` and `remvpn.sh` to change `vpndir` and `easyrsa` near the top.
- Edit `vpn-message.txt` to reflect your own setup, I left my modified information in it as a template. If you don't want email functions, don't worry about it.
- Edit `vpnstat.sh` to change the openvpn status log file to match.

## usage
### Add
~~~bash
sudo ./adduser.sh Bob_Builder bob@userguy.com.net
~~~
If you don't wish to use email
~~~bash
sudo ./adduser.sh Bob_Builder none
~~~

### Remove
~~~bash
sudo ./remuser.sh Bob_Builder
~~~

### List of Users
~~~bash
sudo ./adduser.sh list
or
sudo ./remuser.sh list
~~~
### Is anyone connected?!
~~~bash
sudo ./vpnstat.sh
~~~

### Thoughts and Prayers
I hope I didn't bork anything while converting it to be more easily modified by other users.
