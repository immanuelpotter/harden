#!/bin/bash

legacy_plus_entries(){
  FILE="$1"
  legacy_plus_entries="$(grep '^+:' $FILE)"
    if [[ $legacy_plus_entries ]] ; then
      echo "Legacy plus entries found in $FILE. Please remove: ${legacy_plus_entries}" 
    fi
}
