#!/bin/bash

# Quick utility to run post-hardening so the vagrant user can get back in the box via ssh

USERS_TO_ALLOW_IN="vagrant"

allow_hosts_back_in(){
  sed -i '/^ALL/d' /etc/hosts.deny
}

add_users_to_wheel(){
for i in $USERS_TO_ALLOW_IN ; do
  usermod -aG wheel ${i}
done
}

allow_hosts_back_in
add_users_to_wheel
