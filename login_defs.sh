#!/bin/bash
# Dependency on grep_check.sh - not in main as needs other things to be done such as chage
# Change number to be the maximum number of days before a password must be changed.
# Likely to edit this post-pentest
#
# Populate users_to_chage below
#
#. grep_check.sh

check_max_pw_expiry(){
  grep_check "PASS_MAX_DAYS" /etc/login.defs "PASS_MAX_DAYS ${PASS_MAX_DAYS}"
}

check_min_pw_expiry(){
  grep_check "PASS_MIN_DAYS" /etc/login.defs "PASS_MIN_DAYS ${PASS_MIN_DAYS}"
}

check_pass_warn_days(){
  grep_check "PASS_WARN_AGE" /etc/login.defs "PASS_WARN_AGE ${PASS_WARN_AGE}"
}

inactive_password_lock(){
  useradd -D -f $DISABLE_AFTER_EXPIRATION
}

chage_user_expiry(){
  user="$1"
  chage --maxdays $PASS_MAX_DAYS $user
  chage --mindays $PASS_MIN_DAYS $user
  chage --warndays $PASS_WARN_DAYS $user
  chage --inactive $DISABLE_AFTER_EXPIRATION $user
}
