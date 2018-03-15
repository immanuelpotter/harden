#!/bin/bash

#Ensures no world-writable directories exist without the sticky bit set.

sticky_results="$(df --local -P | awk '(NR!=1){print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null)"

sticky_logic(){
  if [[ ${#sticky_results} -eq 0 ]] ; then 
    echo -e "Sticky bit set on all world-writable directories. \n" 
  else
    echo -e "Sticky bit not set on all world-writable directories. Fixing..." 
    sleep 1
    df --local -P | awk '(NR!=1){print $6}' | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t
    echo "Sticky bit should now be set on all w-w dirs." 
  fi
}
