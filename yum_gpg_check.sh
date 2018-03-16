#!/bin/bash

gpg_bool_logic(){
  file="$1"
  check_result="$(grep ^gpgcheck ${file})"
  if [[ "$check_result" == "gpgcheck=1"  ]] ; then
    echo "${file} is enforcing GPG check." 
  else
    if [[ ${#check_result} -eq 0 ]] ; then
      echo "gpgcheck=1" >> ${file}
      echo "gpgcheck=1 added to $file" 
    else
      sed -i 's/gpgcheck=0/gpgcheck=1/' "${file}"
      echo "Edited ${file} to contain gpg checking" 
    fi
  fi
}
