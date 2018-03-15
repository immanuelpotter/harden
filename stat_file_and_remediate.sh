#!/bin/bash

stat_file_and_remediate(){
  # Give mode in XXXX format
  file="$1"
  mode_wanted="$2"
  owner_wanted="$3"
  group_wanted="$4"
  actual_mode="$(stat $file) | awk '/Access \(/{print $2}' | cut -c2-5"
  chown ${owner_wanted}:${group_wanted} $file
  echo "$file is now owned by ${owner_wanted} and in group ${group_wanted}" 
  if [[ $actual_mode != $mode_wanted ]] ; then
    chmod $mode_wanted $file
    echo "File $file changed to mode $mode_wanted" 
  fi
}
