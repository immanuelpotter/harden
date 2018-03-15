#!/bin/bash

active_wireless_ifs="$(ip link show | awk '$1 ~ /^w/{print $2}' | tr ':' ' ')"

bring_down_wireless_ifs(){
  for wirelessif in $active_wireless_ifs ; do
    ip link set $wirelessif down
    echo "Interface $wirelessif brought down" 
  done
}
