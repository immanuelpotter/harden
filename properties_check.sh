#!/bin/bash

#Work in progress - commented out for running without

#Properties_tmp applies to /tmp, /var/tmp, /dev/shm
#Properties_home just applies to /home

#TODO: mkdir for /etc/systemd/system/local-fs.target.wants?

#check_properties_tmp(){
#  partition="$1"
#  property_in_question="$2"
#  option="$(mount | grep $partition | grep ${property_in_question})"
#  if [[ -z $option ]] ; then
#      edit_systemd
#    else
#      echo "Option ${j} found for ${partition}." 
#    fi
#    if [[   ]] ; then
#      echo "Option ${j} NOT found for ${partition} - fixing:"
#       sed -i.${BACKUP} 's/'${partition}'/'${partition},'/' /etc/systemd/system/local-fs.target.wants/${partition}.mount
#    fi
#  done
#}

#check_properties_home(){
#  partition="$1"
#  property_in_question="$2"
#  option="$(mount | grep $partition | grep $property_in_question)"
#}

#edit_systemd_tmp(){
#  echo -e "[Mount]\nOptions=mode=1777,strictatime,noexec,nodev,nosuid" >> /etc/systemd/system/local-fs.target.wants/tmp.mount
#}
#
#edit_fstab_home(){
#  echo -e "[Mount]\nOptions"
#}
#
#remount(){
#  partition="$1"
#  option="$2"
#  mount -o remount,${option} ${partition}
#}
