#!/bin/bash
#
# CIS Benchmark Standard CentOS 7 v2.1.1
#
# Notes:    Post-hardening report can be found in same dir as this script, called hardening-report.txt
#
# Originally this script was just for checking filesystem types were blocked, but has now evolved to block uncommon network protocols too from dccp onwards in below list

ensure_fs_lsmod(){
  filesystem="$1"
  modprobe_output="$(modprobe -n -v ${filesystem})"
  lsmod_output="$(lsmod | grep ${filesystem})"
  if [[ ${#lsmod_output} -eq 0 ]] ; then
    echo "No lsmod output for ${filesystem} - verified" 
  else
    echo "Module found in kernel for ${filesystem} - consider removing" 
  fi
}

ensure_fs_modprobe(){
  filesystem="$1"
  modprobe_output="$(modprobe -n -v ${filesystem})"
  modprobe_contains_install_bin_true="$(echo "${modprobe_output}" | awk '/install \/bin\/true/{print $1,$2}')"
  if [[ "$modprobe_contains_install_bin_true" != "install /bin/true" ]] ; then
    echo "install ${filesystem} /bin/true" | tee -a /etc/modprobe.d/CIS.conf
  fi
}
