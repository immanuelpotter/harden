#!/bin/bash

# Has evolved to include enablement of services aswell as disabling

if_enabled_then_disable(){
  service="$1"
  result="$(systemctl is-enabled ${service})"
  if [[ ${#result} -eq 0 ]] ; then
    echo "Service $service is not installed. Good!"
  elif [[ -n $result && $result == 'disabled' ]] ; then
    echo "Service $service is disabled. Good!"
  else
    echo "${service} not disabled. Disabling..."
    systemctl disable $service && echo "Successfully disabled"
  fi
}

if_disabled_then_enable(){
  service="$1"
  result="$(systemctl is-enabled ${service})"
  if [[ $result != 'enabled' ]] ; then
    echo "${service} not enabled." 
    systemctl enable $service && echo "Successfully enabled"
  else
    echo "Service $service is enabled. Good!" 
  fi
}
