#!/bin/bash

lock_users_with_no_pass(){
  NO_PASSWORD_USERS="$(cat /etc/shadow | awk -F: '($2 == ""){print $1}')"
  for nopass in $NO_PASSWORD_USERS ; do
    passwd -l $nopass
  done
}
