#!/bin/bash

aide_initialise(){
  aide --init
  mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
  echo "aide installed and activated"
}
