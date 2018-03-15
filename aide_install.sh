#!/bin/bash

aide_version="$(rpm -q aide)"

if [[ $aide_version == 'package aide is not installed' ]] ; then
  echo "${aide_version}" 
  yum install aide
fi
aide --init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
echo "aide installed and activated"
