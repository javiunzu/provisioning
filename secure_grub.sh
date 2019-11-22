#!/bin/bash
# Secures the bootloader by setting a superuser password.
# Users who want to change menu entries or open a console must authenticate.
# This password is disabled for booting entries for convenience, as the next
# authentication is made by the OS itself.
# This script is not for expert users, it is to be used on top of a fresh 
# Debian or Ubuntu installation.
set -eu
echo "Protecting GRUB with a password"
if [ "$(whoami)" != 'root' ];then
    echo 'Please start as root'
fi
# Setting a global password for the console and edition of entries.
echo -n "GRUB Username: "
read USER
echo -n "GRUB Password: "
read -s PASS
HASHED="$(echo -e "${PASS}\n${PASS}\n"|grub-mkpasswd-pbkdf2 | awk '/^PBKDF2 hash/{print $NF}')"
FILE=/etc/grub.d/40_custom
echo "set superusers=\"${USER}\"" >> $FILE
echo "password_pbkdf2 ${USER} ${HASHED}" >> $FILE
# No need to password protect the entries to run
mv /etc/grub.d/10_linux{,.bak}  # Just in case.
chmod -x /etc/grub.d/10_linux.bak
cat /etc/grub.d/10_linux.bak | awk '/echo "menuentry/{gsub("\$\{CLASS\}","${CLASS} --unrestricted");};{print}' > /etc/grub.d/10_linux
chmod +x /etc/grub.d/10_linux
# Commit changes
update-grub

