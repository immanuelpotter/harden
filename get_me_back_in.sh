#!/bin/bash

# Quick utility to run post-hardening so the vagrant user can get back in the box via ssh

USERS_TO_ALLOW_IN="vagrant"
LOCAL_NETWORK:="10.0.2"

add_users_to_wheel(){
for i in $USERS_TO_ALLOW_IN ; do
  usermod -aG wheel ${i}
done
}

main(){
  add_users_to_wheel
}

main
