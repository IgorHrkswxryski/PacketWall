# PacketWall
Lil' script to test outbound traffic from a client to a server. It will help you to find a way to go outside from a local "firewalled" network...

# Usage
Execute `sudo bash server.sh` on your server (on the Internet), then, scan this server from the client (on the LAN) you want to test the possible path (open ports) to reach your server.

# Aim ?
It will help you to audit your outbound traffic policy from your local network to internet. Otherwise it will help you find a way to extract data or spawn a remote shell from a LAN to a C&C...

# How it works ?
On the server, this script will redirect all ports (except port TCP 22) to one port (12345) and it will spawn a netcat listenner on this port (all 65535 ports of the server will appear as open). So, When you will scan this server, it will show you the outbound firewall policy of your local network.

# TODO
* Add supportfor other OS (eg. MAC OS with pfctl client)
* Make UDP Wall scanner works properly
