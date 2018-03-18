#!/bin/bash

# Lock out users after n unsuccessful consecutive login attempts has been omitted. Add deny=<number> after "silent" in first, second and fourth lines to deny entry after <number> tries.
# Dependency on grep_check.sh to be sourced first
# User can be unlocked with faillock -u --reset 

#. grep_check.sh

pam_configure(){
  grep_check "pam_pwquality.so" /etc/pam.d/password-auth 'password requisite pam_pwquality.so try_first_pass retry=3'
  grep_check "^minlen" /etc/security/pwquality.conf 'minlen=14'
  grep_check "^dcredit" /etc/security/pwquality.conf 'dcredit=-1'
  grep_check "^lcredit" /etc/security/pwquality.conf 'lcredit=-1'
  grep_check "^ocredit" /etc/security/pwquality.conf 'ocredit=-1'
  grep_check "^ucredit" /etc/security/pwquality.conf 'ucredit=-1'
}

pam_pw_lockouts(){
  grep_check "^auth required pam_faillock.so preauth audit" /etc/pam.d/password-auth 'auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900'
  grep_check "auth [success=1 default=bad] pam_unix.so" /etc/pam.d/system-auth 'auth [success=1 default=bad] pam_unix.so'
  grep_check "auth [default=die] pam_faillock.so authfail audit unlock_time=900" /etc/pam.d/system-auth 'auth [default=die] pam_faillock.so authfail audit unlock_time=900'
  grep_check "auth sufficient pam_faillock.so authsucc audit unlock_time=900" /etc/pam.d/system-auth 'auth sufficient pam_faillock.so authsucc audit unlock_time=900'
}

pam_pw_remember(){
  grep_check "^password\s+sufficient\s+pam_unix.so\s+remember" /etc/pam.d/password-auth 'password sufficient pam_unix.so remember=5'
  grep_check "^password\s+sufficient\s+pam_unix.so\s+remember" /etc/pam.d/system-auth 'password sufficient pam_unix.so remember=5'
}

pam_pw_sha512(){
  grep_check "^password\s+sufficient\s+pam_unix.so\s+sha" /etc/pam.d/password-auth 'password sufficient pam_unix.so sha512'
  grep_check "^password\s+sufficient\s+pam_unix.so\s+sha" /etc/pam.d/system-auth 'password sufficient pam_unix.so sha512'
}


pam_su_restriction(){
  sed -i '6 s/^#//' /etc/pam.d/su
}
