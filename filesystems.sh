#!/bin/bash
set -eu
# Have a check on some filesystem permissions.
if [ "$(whoami)" != 'root' ];then
    echo 'Please start this script as root.'
    exit 1
fi

# Home directories should never be accesible to others.
chmod -R o-rwx /home
# And set the umask properly so that it stays that way.
echo 'umask 027' >> /etc/profile
echo 'umask 027' >> /etc/skel/.profile
# In fact, if there is a separate partition for the home, set fmask and dmask.
# Don't do this on other partitions unless you know what you are doing.

