#!/bin/bash
set -eu

if [ "$(whoami)" != 'root' ];then
    echo 'Please start this script as root.'
    exit 1
fi

wget 'https://github.com/CISOfy/lynis/archive/master.zip'
unzip master.zip
cd lynis-master
./lynis audit system

