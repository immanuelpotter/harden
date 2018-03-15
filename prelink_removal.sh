#!/bin/bash

remove_prelink(){
prelink_status="$(rpm -q prelink)"
if [[ $prelink_status != 'package prelink is not installed' ]] ; then
  prelink -ua
  yum remove prelink
  echo "Prelink removed." 
else
  echo "Prelink is not installed. Good!" 
fi
}
