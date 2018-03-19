#!/bin/bash


superusr_check(){
  superusers="$(grep "^set superusers" /boot/grub2/grub.cfg)"
  echo -e "\nGRUB superusers: ${superusers}\nPLEASE CHECK that this list is as you were expecting, and if not, change according to site policy in /boot/grub2/grub.cfg\n" 
}

superpass_check(){
  pass="$(grep "password" /boot/grub2/grub.cfg)"
  if [[ -z $pass ]] ; then
    echo "WARNING - doesn't look like a GRUB password is set. This means an attacker with physical access could interrupt the boot sequence and gain a root shell. Check /boot/grub2/grub.cfg" 
  fi
}

#
# If these checks have failed, you should do the following:
# grub2-mkpasswd-pbkdf2
# (This will encrypt a password you enter)
# 
# Add this to /etc/grub.d/01_users or a custom /etc/grub.d config file:
#
# cat <<EOF
# set superusers="<username>"
# password_pbkdf2 <username> <encrypted-password>
# EOF
#
# Update the configuration:
# grub2-mkconfig > /boot/grub2/grub.cfg
#
