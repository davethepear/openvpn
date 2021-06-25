# openvpn
Add &amp; Remove OpenVPN Users with Ease

## Programs needed
To use it you have to, of course, have 
-OpenVPN Server
-EasyRSA
-mutt (if you want to use email installed...

Instructions on installing OpenVPN and Clients: http://www.linncountykansas.com/install_openvpn_server.html

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
~~~
