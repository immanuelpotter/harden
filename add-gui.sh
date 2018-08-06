#!/bin/bash

add-gui(){
  yum groupinstall -y "GNOME Desktop" "Graphical Administration Tools"
  if [[ "$?" -eq 0 ]] ; then
    ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
  fi
}
