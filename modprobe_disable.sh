#!/bin/bash

services_to_disable_modprobe="ipv6"

modprobe_config(){
  disbl="$1"
  modprobe_status="$(modprobe -c | grep ${disbl})"
  if [[ $modprobe_status == "options ${disbl} disable=1" ]] ; then
    echo "$disbl already disabled in /etc/modprobe.d/CIS.conf" 
  else
    echo "options $disbl disable=1" >> /etc/modprobe.d/CIS.conf
    echo "$disbl is now disabled in /etc/modprobe.d/CIS.conf" 
  fi
}
