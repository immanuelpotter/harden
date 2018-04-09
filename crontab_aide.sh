#!/bin/bash

aide_crontab="$(grep "aide" /etc/crontab)"
if [[ -z "$aide_crontab" ]] ; then
  echo "0 5 * * * /sbin/aide --check" >> /etc/crontab
fi
