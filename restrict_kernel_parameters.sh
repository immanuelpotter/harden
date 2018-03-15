#!/bin/bash

hard_core="$(grep "hard core" /etc/security/limits.conf /etc/security/limits.d/*)"

check_core_hard(){
  if [[ $hard_core != '* hard core 0' ]] ; then
    echo "* hard core 0" >> /etc/security/limits.conf
  fi
}

check_kernel_parameter(){
  krn_prm="$1"
  value_to_become="$2"
  kernel_param_value="$(sysctl ${krn_prm})"
  krnprm_found_in_sysctl_bool="$(grep "^${krn_prm}" /etc/sysctl.conf)"
  sysctl -w ${krn_prm}=${value_to_become}
  if [[ -z $krnprm_found_in_sysctl_bool ]] ; then
    echo "${krn_prm}=${value_to_become}" >> /etc/sysctl.conf
    echo "Kernel parameter ${krn_prm} changed to ${value_to_become}" 
  fi
  if [[ $kernel_param_value != "${krn_prm}=${value_to_become}" ]] ; then
     sed -i.${BACKUP} 's/^'${krn_prm}'\s*=\s*[0-9]+/'${krn_prm}'='${value_to_become}'/g' /etc/sysctl.conf
    echo "Kernel parameter $krn_prm changed to $value_to_become" 
  fi
}
