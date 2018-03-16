#!/bin/bash

nologin_sysaccounts(){
  for user in $(awk -v UID_THRESHOLD_FOR_LOCKING=${UID_THRESHOLD_FOR_LOCKING} -F: '($3 < UID_THRESHOLD_FOR_LOCKING ) {print $1}' /etc/passwd) ; do
    if [ $user != "root" ]; then
      usermod -L $user && echo "User $user account locked" 
      if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]; then 
        usermod -s /sbin/nologin $user && echo "User $user shell set to /sbin/nologin"
      fi
    fi
  done
}
