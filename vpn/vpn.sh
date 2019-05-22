#!/bin/bash
modprobe nf_conntrack_pptp
modprobe nf_conntrack_proto_gre
pon $1
interv=10
echo "waiting "$interv"s vpn works..."
sleep $interv
ip route replace default dev ppp0
echo "all have finished!"

