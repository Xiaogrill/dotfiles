#!/bin/bash

if [ `id -u` != 0 ]; then
    echo "sudo password"
    exec sudo `realpath $0` "$@"
fi

set -e

echo "simple-crypt password"
simple-crypt daemon start
simple-crypt daemon add key

FILES=("r/home/motoko/.net.conf" "r/home/motoko/.bashrc" "r/home/motoko/xiao.kdb" "r/home/motoko/.ssh/config")

for i in ${FILES[@]}; do
    simple-crypt daemon decrypt $i.enc $i
    chmod $(stat `dirname $i` -c %a) $i
    chown $(stat `dirname $i` -c %u:%g) $i
    mv $i.enc ./
done

cp -a r/* /

for i in ${FILES[@]}; do
    rm $i
    mv `basename $i`.enc `dirname $i`
done

simple-crypt daemon stop
