#!/bin/sh
set -e
dd if=/dev/zero of=/overlay/swapfile bs=1M count=2048
chmod 600 /overlay/swapfile
mkswap /overlay/swapfile

uci set fstab.@global[0].anon_swap='1'
uci set fstab.@global[0].auto_swap='1'

while uci -q delete fstab.@swap[-1]; do :; done

uci add fstab swap
uci set fstab.@swap[-1].enabled='1'
uci set fstab.@swap[-1].device='/overlay/swapfile'
uci set fstab.@swap[-1].label='foo'


uci commit fstab
reboot
