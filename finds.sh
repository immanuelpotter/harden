#!/bin/bash

find_ww_dirs(){
  echo "Performing checks on world-writable files..."
  local BAD="$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002)"
  if [[ ${#BAD} -gt 0 ]] ; then
      echo -e "The following files: \n ${BAD} \nare world-writable. Check this is supposed to be the case, and if not, remove with chmod o-w."
  fi
}

find_unowned_files_and_dirs(){
  echo "Performing checks on unowned files and directories..."
  local BAD="$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -nouser)"
  if [[ ${#BAD} -gt 0 ]] ; then
    echo -e "The following files and dirs:\n ${BAD} \nhave no owner. Check this is supposed to be the case, and if not, remove them - as new users who may be assigned the old user ID may have more access than intended."
  fi
}

find_ungrouped_files_and_dirs(){
  echo -e "Performing checks on ungrouped files and directories..."
  local BAD="$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -nogroup)"
  if [[ ${#BAD} -gt 0 ]] ; then
    echo -e "The following files and dirs:\n ${BAD} \nhave no group. Check this is supposed to be the case, and if not, remove them - as new users who may be assigned the old group ID may have more access than intended."
  fi
}

audit_suid_executables(){
  echo -e "Performing checks on suid executables..."
  local BAD="$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000)"
  if [[ ${#BAD} -gt 0 ]] ; then
    echo -e "The following files:\n ${BAD} \nhave SUID set. Check this is supposed to be the case, and if not, remove - as users may be able to change their UID and may have more access than intended."
  fi
}

audit_sgid_executables(){
  echo -e "Performing checks on sgid executables..."
  local BAD="$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000)"
  if [[ ${#BAD} -gt 0 ]] ; then
    echo -e "The following files:\n ${BAD} \nhave SGID set. Check this is supposed to be the case, and if not, remove - as users may be able to change their GID and may have more access than intended."
  fi
}
