#!/bin/bash

#Work in progress - commented out for running without

# 1) Check mounted (mount | grep $filesystem)
# 2) Edit /etc/fstab with appropiate properties for $filesystem OR systemd for /tmp
# 3) mount -o remount,properties $filesystem

# tmp applies to /tmp, /var/tmp, /dev/shm
# home just applies to /home

#Dependency on grep_check.sh

#TODO: fix edit_fstab_tmp, + edit_fstab_home

create_local_fs_dir(){
  if [[ ! -d /etc/systemd/system/local-fs.target.wants ]] ; then
    mkdir /etc/systemd/system/local-fs.target.wants
    echo "/etc/systemd/system/local-fs.target.wants created"
  fi
}

make_systemd_tmp(){
  if [[ ! -f /etc/systemd/system/local-fs.target.wants/tmp.mount ]] ; then
    echo '[Mount]' >> /etc/systemd/system/local-fs.target.wants/tmp.mount
    echo "Options=mode=1777,strictatime,noexec,nodev,nosuid" >> /etc/systemd/system/local-fs.target.wants/tmp.mount
  else
    rm -f /etc/systemd/system/local-fs.target.wants/tmp.mount
    echo '[Mount]' >> /etc/systemd/system/local-fs.target.wants/tmp.mount
    echo "Options=mode=1777,strictatime,noexec,nodev,nosuid" >> /etc/systemd/system/local-fs.target.wants/tmp.mount
  fi
}

edit_fstab_tmp(){
  partition="$1"
  changed="defaults,nosuid,nodev,noexec,x-systemd.device-timeout=0"
  mounted="$(mount | grep -w ${partition})"
  # This check should suffice to change /etc/fstab only if partition is mounted, as root is needed to mount partitions anyway
  if [[ -n "${mounted}" ]] ; then
    #awk -v partition="${partition}" -v changed="${changed}" '$2 == partition {$4=changed}' /etc/fstab 
    sed -r '@'${partition}'@!s@(.*) ('${partition}') (.*) (.*) (.*) (.*)@\1 \2 \3 '${changed}' \5 \6' /tmp/fstab.backup
  fi
}


edit_fstab_home(){
  partition="$1"
  changed="defaults,nodev,x-systemd.device-timeout=0"
  mounted="$(mount | grep -w ${partition})"
  # This check should suffice to change /etc/fstab only if partition is mounted, as root is needed to mount partitions anyway
  if [[ -n "${mounted}" ]] ; then
    #awk -v partition="${partition}" -v changed="${changed}" '$2 == partition {$4=changed}' /etc/fstab
    sed -r '@'${partition}'@!s@(.*) ('${partition}') (.*) (.*) (.*) (.*)@\1 \2 \3 '${changed}' \5 \6' /tmp/fstab.backup
  fi
}

remount_home(){
  partition="$1"
  mounted="$(mount | grep -w ${partition})"
  if [[ -n "${mounted}" ]] ; then
    mount -o remount,nodev ${partition} 
  fi
}

remount_tmps(){
  partition="$1"
  mounted="$(mount | grep -w ${partition})"
  if [[ -n "${mounted}" ]] ; then
    mount -o remount,nodev,nosuid,noexec ${partition}
  fi
}
