#!/bin/bash
set -eu
# Set up some basic firewall rules. Monitor the firewall activity with:
#    tail -f /var/log/ufw.log
# This script also sets a fixed DNS resolution, overriding whatever a DHCP
# lease may say. You can see this as another measure to limit traffic :)

if [ "$(whoami)" != 'root' ];then
    echo "Please start as root."
    exit 1
fi
dns_server='1.1.1.1'
echo "supersede domain-name-servers ${dns_server}" >> /etc/dhcp/dhclient.conf
sed -i "/nameserver/d" /etc/resolv.conf
echo "nameserver ${ḍns_server}" >> /etc/resolv.conf

apt install -y gufw
ufw enable
# Default policy: DENY!
ufw default deny incoming
ufw default deny forward
ufw default deny outgoing

ufw allow out to "${dns_server}" proto udp port 53 comment 'Cloudflare DNS'
ufw allow out to any proto tcp port 80 comment 'Allow HTTP'
ufw allow out to any proto tcp port 443 comment 'Allow HTTPS'

