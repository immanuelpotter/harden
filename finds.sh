#!/bin/bash

find_ww_dirs(){
  echo -e "World-writable check\nThe following dirs: \n$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002) \nare world-writable. Check this is supposed to be the case, and if not, remove with chmod o-w." 
}

find_unowned_files_and_dirs(){
  echo -e "Unowned check\nThe following files and dirs:\n$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -nouser) \nhave no owner. Check this is supposed to be the case, and if not, remove them - as new users who may be assigned the old user ID may have more access than intended." 
}

find_ungrouped_files_and_dirs(){
  echo -e "Ungrouped check\nThe following files and dirs:\n$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -nogroup) \nhave no group. Check this is supposed to be the case, and if not, remove them - as new users who may be assigned the old group ID may have more access than intended." 
}

audit_suid_executables(){
  echo -e "SUID Audit check\nThe following files:\n$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000) \nhave SUID set. Check this is supposed to be the case, and if not, remove - as users may be able to change their UID and may have more access than intended." 
}

audit_sgid_executables(){
echo -e "SGID Audit check\nThe following files:\n$(df --local -P | awk '(NR!=1) {print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000) \nhave SGID set. Check this is supposed to be the case, and if not, remove - as users may be able to change their GID and may have more access than intended." 
}
