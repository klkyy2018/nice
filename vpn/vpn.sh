#!/bin/bash
modprobe nf_conntrack_pptp
modprobe nf_conntrack_proto_gre
pon warpvpn
interv=10
echo "waiting ($interv)s vpn works..."
sleep $interv
ip route replace default dev ppp0
pingres=`ping -c 1 www.google.com | sed -n '/64 bytes from/p'`
if [ -z "$pingres" ]
then
        echo "网络连接失败，请联系管理员" 
else
        echo "网络畅通"
fi
echo "all have finished!"

