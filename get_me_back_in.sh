#!/bin/bash
# Quick utility to run post-hardening so the vagrant OR ec2 user can get back in the box via ssh

find_user(){
  POTENTIAL_USERS="ec2-user vagrant"
  for i in ${POTENTIAL_USERS} ; do
    if [[ ! -z $(cat /etc/passwd | grep potteri) ]] ; then
      global USERS_TO_ALLOW_IN="${i}"
    fi
  done
}

add_users_to_wheel(){
for i in $USERS_TO_ALLOW_IN ; do
  usermod -aG wheel ${i}
done
}

main(){
  add_users_to_wheel
}

main
