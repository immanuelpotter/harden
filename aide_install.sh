#!/bin/bash
aide_crontab(){
  aide_crontab="$(grep "aide" /etc/crontab)"
  if [[ -z "$aide_crontab" ]] ; then
    echo "0 5 * * * root /sbin/aide --check" >> /etc/crontab
  fi
}

aide_initialise(){
  aide --init
  mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
  echo "aide installed and activated"
}
