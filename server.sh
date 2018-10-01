#!/bin/bash

echo "###########################################################################"
echo "# Welcome to PacketWall                                                   #"
echo "# This project will help you find a good path to go outside of a network. #"
echo "# Following is the server side configuration                              #"
echo "###########################################################################"

echo ""
echo "Would you like to backup your netfilter cofiguration ?"
read -p '"yes or no": ' resp

if [ $resp = 'yes' ]
then
    echo "Backuping current Netfilter configuration to /opt/iptables.backup..."
    sudo iptables-save > /opt/iptables.backup
else
    echo "Warning : ignoring backuping of Netfilter configuration !"
fi

echo ""
echo "By continuying this programm, you will redirect all your inbound (TCP and UDP) traffic, except port 22 (e.g. ssh) to a local port (12345)"

echo ""
echo "Would you like to continue (flushing firewall rules and redirect traffic)?"
read -p '"yes or no": ' resp2
if [ $resp2 = 'yes'  ]
then
    echo "Continue script"
else
    echo "Exit script"
    exit
fi

echo ""
echo "/!\\ Flushing all Netfilter rules /!\\"
echo "sudo iptables -F"
echo "sudo iptables -F"
echo "sudo iptables -X"
echo "sudo iptables -t nat -F"
echo "sudo iptables -t nat -X"
echo "sudo iptables -t mangle -F"
echo "sudo iptables -t mangle -X"
echo "sudo iptables -P INPUT ACCEPT"
echo "sudo iptables -P FORWARD ACCEPT"
echo "sudo iptables -P OUTPUT ACCEPT"
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

echo ""
echo "/!\\ Redirect all TCP incoming traffic to a local listenner /!\\"
echo "sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 1:21 -j REDIRECT --to-port 12345"
echo "sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 1:65535 -j REDIRECT --to-port 12345"
sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 1:21 -j REDIRECT --to-port 12345
sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 23:65535 -j REDIRECT --to-port 12345
echo "/!\\ Redirect all UDP incoming traffic to a local listenner /!\\"
echo "sudo iptables -A PREROUTING -t nat -i eth0 -p udp --dport 1:21 -j REDIRECT --to-port 12345"
sudo iptables -A PREROUTING -t nat -i eth0 -p udp --dport 1:65535 -j REDIRECT --to-port 12345

repare() {
    echo ""
    echo "Restore initial firewall configuration"
    sudo iptables-restore /opt/iptables.backup
    echo "sudo iptables-restore /opt/iptables.backup"
    echo "Bye!"
    exit
}
trap repare INT

while true; do
    echo ""
    echo "/!\\ Launching listenner : ncat -lk 12345 /!\\"
    echo "Launch the following command on your cilent to get all output path from it to the server : nmap -sT [SERVER_IP] -p-"
    ncat -lk 12345
done
