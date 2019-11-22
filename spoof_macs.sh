#!/bin/bash
set -eu
if [ "$(whoami)" != 'root' ];then
    echo "Please start this script as root"
    exit 1
fi

apt install -y macchanger

# Create and enable a Systemd service file, as Network-Manager is buggy and
# cannot really change the MAC on system boot.
cat <<EOF> /etc/systemd/system/macspoof@.service
[Unit]
Description=macchanger on %I
Wants=network-pre.target
Before=network-pre.target
After=sys-subsystem-net-devices-%i.device

[Service]
ExecStart=/usr/bin/macchanger -r %I
Type=oneshot

[Install]
WantedBy=multi-user.target

EOF

for interface in $(ip -a -o link | awk '!/lo/{print $2$(NF-2)}');do
    IFS=':' read IFACE MAC <<< $interface
    ip link set $IFACE down
    macchanger -r $IFACE
    # Trim/spoof the vendor info
    ip link set $IFACE up
    systemctl enable macspoof@$IFACE.service
done

