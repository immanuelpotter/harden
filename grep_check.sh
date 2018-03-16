#!/bin/bash

grep_check(){
  string_to_find="$1"
  file_to_check="$2"
  expected="$3"

  # Potentially add logic to create file here
  found_line="$(egrep "${string_to_find}" ${file_to_check})"
  if [[ "$found_line" == "$expected" ]] ; then
    echo "$string_to_find found in $file_to_check and is as expected" 
  else
    if [[ ${#found_line} -gt 0 ]] ; then
       sed -i.${BACKUP} '/'${string_to_find}'/d' $file_to_check
    else
      echo "${string_to_find} not found, adding" 
      echo "$expected" >> "$file_to_check"
      echo "$expected added to file $file_to_check"
     fi
  fi
}
