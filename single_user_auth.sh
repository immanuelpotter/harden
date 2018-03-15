#!/bin/bash

check_rescue_su(){
  res_rescue="$(grep /sbin/sulogin /usr/lib/systemd/system/rescue.service)"
  if [[ -z $res_rescue ]] ; then
    echo "ExecStart=-/bin/sh -c "/sbin/sulogin ; /usr/bin/systemctl --fail --no-block default"" >> /usr/lib/systemd/system/rescue.service
  fi
}

check_emerg_su(){
  res_emerg="$(grep /sbin/sulogin /usr/lib/systemd/system/emergency.service)"
  if [[ -z $res_emerg ]] ; then
    echo "ExecStart=-/bin/sh -c "/sbin/sulogin ; /usr/bin/systemctl --fail --no-block default"" >> /usr/lib/systemd/system/emergency.service
  fi
}
