#!/bin/bash
#
#Ensures that each partition listed below is mounted separately. See the report for details
#
#TODO: fix rest of partition logic checking, this is just for home (and doesn't even work)

home="/home"

mount_check(){
  partition="$1"
  mount_result="$(mount | grep -w ${partition})"
  equals_string="tmpfs on ${partition} type ${partition} (rw,nosuid,nodev,noexec,relatime)"
  if [[ $mount_result != $equals_string ]] ; then
    echo "${partition} not mounted correctly according to CIS benchmark server level 2." 
  else
    echo "${partition} appears to be mounted correctly according to CIS benchmark server level 2." 
  fi
}
