#!/bin/bash

UID_THRESHOLD=1000

root_uid_check(){
  uid_zero="$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')"
  if [[ $uid_zero != 'root' ]] ; then
    echo "WARNING - more than one user with UID 0! Please check /etc/passwd immediately." 
  fi
}

root_path_check(){
  empty_dir="$(echo $PATH | grep ::)" 
  [[ $empty_dir ]] && echo "WARNING - Empty Dir in PATH! Remove this" 
  path_split="$(echo $PATH | tr ':' '\n')"
  current_dir="$(echo $path_split | grep "\.")"
  [[ $current_dir ]] && echo "WARNING - Current Dir in PATH! Remove this" 
}

ensure_home_dirs_exist(){
cat /etc/passwd | awk -F: '{ print $1 " " $3 " " $6 }' | while read user uid dir; do
  if [ $uid -ge $UID_THRESHOLD -a ! -d "$dir" -a $user != "nfsnobody" ]; then
    echo "The home directory ($dir) of user $user does not exist." 
  fi
done
}

ensure_users_home_dirs_perms(){
  for dir in `cat /etc/passwd | egrep -v '(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin") { print $6 }'`; do
    dirperm=`ls -ld $dir | cut -f1 -d" "`
    if [ `echo $dirperm | cut -c6` != "-" ]; then
      echo "Group Write permission set on directory $dir" 
    fi
    if [ `echo $dirperm | cut -c8` != "-" ]; then
      echo "Other Read permission set on directory $dir" 
    fi
    if [ `echo $dirperm | cut -c9` != "-" ]; then
      echo "Other Write permission set on directory $dir" 
    fi
    if [ `echo $dirperm | cut -c10` != "-" ]; then
      echo "Other Execute permission set on directory $dir" 
    fi
  done
}

ensure_users_own_home_dirs(){
  cat /etc/passwd | awk -F: '{ print $1 " " $3 " " $6 }' | while read user uid dir; do
    if [ $uid -ge $UID_THRESHOLD -a -d "$dir" -a $user != "nfsnobody" ]; then
      owner=$(stat -L -c "%U" "$dir")
      if [ "$owner" != "$user" ]; then
        echo "The home directory ($dir) of user $user is owned by $owner." 
      fi
    fi
  done
}

ensure_users_dot_files_perms(){
for dir in `cat /etc/passwd | egrep -v '(root|sync|halt|shutdown)' | awk -F: '($7 != "/sbin/nologin") { print $6 }'`; do
  for file in $dir/.[A-Za-z0-9]*; do
    if [ ! -h "$file" -a -f "$file" ]; then
      fileperm=`ls -ld $file | cut -f1 -d" "`

    if [ `echo $fileperm | cut -c6` != "-" ]; then
      echo "Group Write permission set on file $file" 
    fi
    if [ `echo $fileperm | cut -c9` != "-" ]; then
      echo "Other Write permission set on file $file" 
    fi
  fi
  done
done
}

ensure_no_dot_forwards(){
for dir in `cat /etc/passwd |\
  awk -F: '{ print $6 }'`; do
  if [ ! -h "$dir/.forward" -a -f "$dir/.forward" ]; then
    echo ".forward file $dir/.forward exists" 
  else
    echo "No .forward files found - good!" 
  fi
done
}

ensure_no_netrcs(){
for dir in `cat /etc/passwd |\
  awk -F: '{ print $6 }'`; do
  if [ ! -h "$dir/.netrc" -a -f "$dir/.netrc" ]; then
    echo ".netrc file $dir/.netrc exists" 
  else
    echo "No .netrc files found - good!" 
  fi
done
}

ensure_netrcs_not_g_or_o_accessible(){
for dir in `cat /etc/passwd | egrep -v '(root|sync|halt|shutdown)' | awk -F: '($7 != "/sbin/nologin") { print $6 }'`; do
  for file in $dir/.netrc; do
    if [ ! -h "$file" -a -f "$file" ]; then
      fileperm=`ls -ld $file | cut -f1 -d" "`
      if [ `echo $fileperm | cut -c5` != "-" ]; then
        echo "Group Read set on $file - please check and verify allowed" 
      fi
      if [ `echo $fileperm | cut -c6` != "-" ]; then
        echo "Group Write set on $file - please check and verify allowed" 
      fi
      if [ `echo $fileperm | cut -c7` != "-" ]; then
        echo "Group Execute set on $file - please check and verify allowed"  
      fi
      if [ `echo $fileperm | cut -c8` != "-" ]; then
        echo "Other Read set on $file - please check and verify allowed"  
      fi
      if [ `echo $fileperm | cut -c9` != "-" ]; then
        echo "Other Write set on $file - please check and verify allowed"  
      fi
      if [ `echo $fileperm | cut -c10` != "-" ]; then
        echo "Other Execute set on $file - please check and verify allowed"  
      fi
    fi
  done
done
}

ensure_no_rhosts_files(){
for dir in `cat /etc/passwd | egrep -v '(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin") { print $6 }'`; do
  for file in $dir/.rhosts; do
    if [ ! -h "$file" -a -f "$file" ]; then
      echo ".rhosts file in $dir - should delete" 
    else
      echo "No rhosts files found - good!" 
    fi
  done
done
}

ensure_all_groups_in_passwd_exist_in_group(){
for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
  grep -q -P "^.*?:[^:]*:$i:" /etc/group
  if [ $? -ne 0 ]; then
    echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group" 
  else
    echo "All groups in /etc/passwd exist in /etc/group - good!" 
  fi
done
}

ensure_no_duplicate_IDs(){
  FILE="$1"
  cat $FILE | cut -f3 -d":" | sort -n | uniq -c | while read x ; do
  [ -z "${x}" ] && break
  set - $x
  if [ $1 -gt 1 ] ; then
    users="$(awk -F: '($3 == n){ print $1 }' n=$2 $FILE | xargs )"
    echo "Duplicate ID ($2): ${users} found - PLEASE INVESTIGATE" 
  else
    echo "No duplicate IDs found - good!" 
  fi
 done
}

ensure_no_duplicate_names(){
  FILE="$1"
  cat $FILE | cut -f1 -d":" | sort -n | uniq -c | while read x ; do
    [ -z "${x}" ] && break
    set - $x
      if [ $1 -gt 1 ]; then
        uids="$(awk -F: '($1 == n) { print $3 }' n=$2 $FILE | xargs)"
        echo "Duplicate Name ($2): ${uids} found - PLEASE INVESTIGATE"
      else
        echo "No duplicate names found - good!" 
      fi
   done
}
