#!/bin/bash

#Ensures that each partition listed below is mounted separately. See the report for details

#TODO: sed into /etc/fstab
#TODO: mkdir for /etc/systemd/system/local-fs.target.wants?

#dirs="/var /tmp /var/log /var/tmp /var/log/audit"
partition_check_dirs="/var /tmp /dev/shm"
home="/home"
properties="nodev nosuid noexec"

mount_check(){
  partition="$1"
  mount_result="$(mount | grep -w ${partition})"
  equals_string="tmpfs on ${partition} type ${partition} (rw,nosuid,nodev,noexec,relatime)"
  if [[ $mount_result != $equals_string ]] ; then
    echo "${partition} not mounted correctly according to CIS benchmark server level 2." 
  else
    echo "${partition} appears to be mounted correctly." 
  fi
}

check_properties(){
  partition="$1"
  for j in ${properties}; do
    options="$(cat /etc/fstab | awk -v Partition="${partition}" '$3 == Partition {print $4}')"
    option_in_question="$(echo $options | grep ${j})"
    if [[ -z $options_in_question ]] ; then
      edit_systemd
    else
      echo "Option ${j} found for ${partition}." 
    fi
    if [[  ]] ; then
      echo "Option ${j} NOT found for ${partition} - fixing:"
       sed -i.${BACKUP} 's/'${partition}'/'${partition},'/' /etc/systemd/system/local-fs.target.wants/${partition}.mount
    fi
  done
}

edit_systemd(){
  echo -e "[Mount]\nOptions=mode=1777,strictatime,noexec,nodev,nosuid" >> /etc/systemd/system/local-fs.target.wants/tmp.mount
}

remount(){
  mount -o remount,nosuid 
}

