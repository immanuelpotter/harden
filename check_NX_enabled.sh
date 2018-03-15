#!/bin/bash

NX_is_active(){
is_active="$(dmesg | grep NX | awk '{print $7}' | head -n1)"
if [[ $is_active != 'active' ]] ; then
  echo "WARNING - NX is not enabled. This means buffer overflow attacks may be easier. Please configure your bootloader to support this." 
else
  echo "NX is active. This will help prevent buffer overflow attacks." 
fi
}
