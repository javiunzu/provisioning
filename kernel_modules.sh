#!/bin/bash
set -eu
if [ "$(whoami)" != 'root' ];then
    echo 'Please start as root'
    exit 1
fi

# Feel free to add or remove modules from the list.
# My choice:
# usbhid to protect against ducky-like devices.
# firewire-core and thunderbolt, because they have full DMA into your system.

cat <<EOF> /etc/modprobe.d/blacklist.conf
blacklist usbhid
blacklist firewire-core
blacklist thunderbolt
EOF

# Persist boot configuration.
update-initramfs -u -k $(uname -r)

