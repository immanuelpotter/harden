#!/bin/bash

update_motd(){
  bad_instances_motd="$(egrep '(\\v|\\m|\\r|\\s)' /etc/motd)"
  if [[ -z $bad_instances_motd ]] ; then
    echo "No bad instances of \m, \r, \s, or \v found." 
  else
    rm -f /etc/motd
    echo "/etc/motd file removed. Please update according to site policy" 
  fi
}
