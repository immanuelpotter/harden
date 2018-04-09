#
# CIS Benchmark Standard CentOS 7 v2.1.1
#
# Server Level 1 Hardening script
#
# Pre-reqs: Place /var, /tmp, and perhaps /var/ /var/log on separate partitions.
#           Should be ran as root.
#
# This is the main wrapper script that runs everything else in sequence.
#
# Notes:    Post-hardening report can be found in same dir as this script, called hardening-report.txt

. variables.env

. issue.sh
. fs_types.sh
. partition_checks.sh
. properties_check.sh
. sticky_bit_check.sh
. systemctl_disabling.sh
. ensure_gpg_configured.sh
. yum_gpg_check.sh
. aide_install.sh
. crontab_aide.sh
. grub_passwd.sh
. single_user_auth.sh
. restrict_kernel_parameters.sh
. update_motd.sh
. check_NX_enabled.sh
. prelink_removal.sh
. stat_file_and_remediate.sh
. disable_services.sh
. grep_check.sh
. wireless_ifs_down.sh
. pam_configuration.sh
. login_defs.sh
. nologin_sysaccounts.sh
. finds.sh
. etc_shadow_lock.sh
. legacy_plus_entries.sh
. further_uid_and_passwd_checks.sh

yum_installations(){
  yum check-update && yum update -y
  yum install -y ntp \
                 chrony \
                 net-tools \
                 tcp_wrappers \
                 iptables \
                 rsyslog
}

fs_types_main(){
  for fs_type in $fs_list_disable_modprobe ; do
    ensure_fs_lsmod ${fs_type}
    ensure_fs_modprobe ${fs_type}
  done
  echo
}

partition_checks_main(){
  for i in $partition_check_dirs; do
    mount_check ${i}
  done
}

systemctl_disabling_main(){
  for srv_d in $systemctl_services_to_disable ; do
    if_enabled_then_disable $srv_d
  done
  for srv_e in $systemctl_services_to_enable ; do
    if_disabled_then_enable $srv_e
  done
}

yum_gpg_check_main(){
  declare -a files_to_check
  files_to_check+=(/etc/yum.conf)
  for repo in "$(ls /etc/yum.repos.d)" ; do
    files_to_check+=(/etc/yum.repos.d/${repo})
  done
  for f in ${files_to_check[@]} ; do
    gpg_bool_logic $f
  done
}

single_user_auth_main(){
  check_rescue_su
  check_emerg_su
}

yum_removals(){
  yum_removals="xorg-x11* rpbind rsh talk telnet openldap-clients"
  for yumrmv in $yum_removals ; do
    yum remove $yumrmv -y
  done
}

restrict_kernel_parameters_main(){
  check_core_hard
  check_kernel_parameter fs.suid_dumpable 0
  check_kernel_parameter net.ipv4.conf.default.send_redirects 0
  check_kernel_parameter net.ipv4.conf.all.send_redirects 0
  check_kernel_parameter net.ipv4.conf.default.accept_redirects 0
  check_kernel_parameter net.ipv4.conf.all.accept_redirects 0
  check_kernel_parameter net.ipv4.conf.default.secure_redirects 0
  check_kernel_parameter net.ipv4.conf.all.secure_redirects 0
  check_kernel_parameter net.ipv4.conf.default.log_martians 1
  check_kernel_parameter net.ipv4.conf.all.log_martians 1
  check_kernel_parameter net.ipv6.conf.all.accept_ra 0
  check_kernel_parameter net.ipv6.conf.default.accept_ra 0
  check_kernel_parameter net.ipv6.conf.all.accept_redirects 0
  check_kernel_parameter net.ipv6.conf.default.accept_redirects 0
  check_kernel_parameter kernel.randomize_va_space 2
  check_kernel_parameter net.ipv4.ip_forward 0
  check_kernel_parameter net.ipv4.conf.all.accept_source_route 0
  check_kernel_parameter net.ipv4.conf.default.accept_source_route 0
  check_kernel_parameter net.ipv4.icmp_echo_ignore_broadcasts 1
  check_kernel_parameter net.ipv4.icmp_ignore_bogus_error_responses 1
  check_kernel_parameter net.ipv4.conf.all.rp_filter 1
  check_kernel_parameter net.ipv4.conf.default.rp_filter 1
  check_kernel_parameter net.ipv4.tcp_syncookies 1

  #Must be done last
  sysctl -w net.ipv4.route.flush=1
  sysctl -w net.ipv6.route.flush=1
}

stat_file_and_remediate_main(){
  stat_file_and_remediate /etc/motd 0644 root root
  stat_file_and_remediate /etc/issue 0644 root root
  stat_file_and_remediate /etc/issue.net 0644 root root
  stat_file_and_remediate /boot/grub2/grub.cfg 0600 root root
  stat_file_and_remediate /etc/hosts.allow 0644 root root
  stat_file_and_remediate /etc/hosts.deny 0644 root root
  stat_file_and_remediate /etc/crontab 0600 root root
  stat_file_and_remediate /etc/cron.hourly 0600 root root
  stat_file_and_remediate /etc/cron.daily 0600 root root
  stat_file_and_remediate /etc/cron.weekly 0600 root root
  stat_file_and_remediate /etc/cron.monthly 0600 root root
  stat_file_and_remediate /etc/cron.d 0600 root root
  stat_file_and_remediate /etc/ssh/sshd_config 0600 root root
  stat_file_and_remediate /etc/passwd 0644 root root
  stat_file_and_remediate /etc/shadow 0000 root root
  stat_file_and_remediate /etc/group 0644 root root
  stat_file_and_remediate /etc/gshadow 0000 root root
  stat_file_and_remediate /etc/passwd- 0600 root root
  stat_file_and_remediate /etc/shadow- 0600 root root
  stat_file_and_remediate /etc/group- 0600 root root
  stat_file_and_remediate /etc/gshadow- 0600 root root
  stat_file_and_remediate /etc/cron.allow 0700 root root
}

no_crondeny_or_cronallow(){
  stat /etc/cron.deny && rm /etc/cron.deny || echo "cron.deny does not exist. Good!"
}

disable_services_main(){
  for disbl in $services_to_disable ; do
    disable_service $disbl
  done
}

grep_check_main(){
  #ntp
  grep_check "^restrict\s+-4" /etc/ntp.conf 'restrict -4 default kod nomodify notrap nopeer noquery'
  grep_check "^restrict\s+-6" /etc/ntp.conf 'restrict -6 default kod nomodify notrap nopeer noquery'
  grep_check "^OPTIONS=" /etc/sysconfig/ntpd 'OPTIONS="-u ntp:ntp"'
  grep_check "^ExecStart=/usr/sbin/ntpd" /usr/lib/systemd/system/ntpd.service 'ExecStart=/usr/sbin/ntpd/ -u ntp:ntp $OPTIONS'
  #chrony
  grep_check "^OPTIONS" /etc/sysconfig/chronyd 'OPTIONS="-u chrony"'
  #postfix
  grep_check "^inet_interfaces" /etc/postfix/main.cf 'inet_interfaces = localhost'
  #rsyslog
  
  #Three files below grep check doesn't work for - commented out to investigate.
  #Bottom two can stay commented anyway as not trying to create a log host.

  #grep_check "^\$FileCreateMode" /etc/rsyslog.conf '$FileCreateMode 0640'
  sed -i '/^$FileCreateMode/d' /etc/rsyslog.conf
  echo -e "\$FileCreateMode 0640" >> /etc/rsyslog.conf
  
  # Leave the lines below commented if you DON'T want the box to be a designated log host.

  # grep_check '#$ModLoad imtcp.so' /etc/rsyslog.conf '#$ModLoad imtcp.so'
  # grep_check '#$InputTCPServerRun' /etc/rsyslog.conf '#$InputTCPServerRun 514'
  
  #sshd
  grep_check "^Protocol" /etc/ssh/sshd_config 'Protocol 2'
  grep_check "^LogLevel" /etc/ssh/sshd_config 'LogLevel INFO'
  grep_check "^X11Forwarding" /etc/ssh/sshd_config 'X11Forwarding no'
  grep_check "^MaxAuthTries" /etc/ssh/sshd_config 'MaxAuthTries 4'
  grep_check "^IgnoreRhosts" /etc/ssh/sshd_config 'IgnoreRhosts yes'
  grep_check "^HostbasedAuthentication" /etc/ssh/sshd_config 'HostbasedAuthentication no'
  grep_check "^PermitRootLogin" /etc/ssh/sshd_config 'PermitRootLogin no'
  grep_check "^PermitEmptyPasswords" /etc/ssh/sshd_config 'PermitEmptyPasswords no'
  grep_check "^PermitUserEnvironment" /etc/ssh/sshd_config 'PermitUserEnvironment no'
  grep_check "Ciphers" /etc/ssh/sshd_config 'Ciphers aes256-ctr,aes192-ctr,aes128-ctr'
  grep_check "MACs" /etc/ssh/sshd_config 'MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com'
  grep_check "^ClientAliveInterval" /etc/ssh/sshd_config 'ClientAliveInterval 300'
  grep_check "^ClientAliveCountMax" /etc/ssh/sshd_config 'ClientAliveCountMax 0'
  grep_check "^LoginGraceTime" /etc/ssh/sshd_config 'LoginGraceTime 60'
  grep_check "^AllowGroups" /etc/ssh/sshd_config 'AllowGroups wheel'
  grep_check "^DenyUsers" /etc/ssh/sshd_config 'DenyUsers all'
  grep_check "^Banner" /etc/ssh/sshd_config 'Banner /etc/issue.net'

  # Disable ipv6 - removing singular modprobe function created just for this
  grep_check "^options ipv6" /etc/modprobe.d/CIS.conf 'options ipv6 disable=1'
}

restart_services_main(){
  to_restart="postfix auditd sshd"
  for rst in $to_restart ; do
    systemctl restart $rst && echo "Restarted $rst service"
  done
  # start up AIDE
  systemctl start aide
  # rsyslogd restarted with a HUP signal
  pkill -HUP rsyslogd
  echo "Sent HUP signal to rsyslogd"
}

login_defs_main(){
  check_max_pw_expiry
  check_min_pw_expiry
  inactive_password_lock
  for user_xpr in $users_to_expire ; do
    chage_user_expiry $user_xpr
  done
}

pam_main(){
  pam_configure
  pam_pw_lockouts
  pam_pw_remember
  pam_pw_sha512
  pam_su_restriction
}

deny_hosts(){
  echo "ALL: ALL" >> /etc/hosts.deny
  echo "All hosts denied SSH access"
}

log_file_permissions_set(){
  find /var/log -type f -exec chmod g-wx,o-rwx {} +
  echo "All others permissions revoked on log files. All write/execute permissions for groups removed from log files."
}

usermod_changes(){
  usermod -g 0 root
  grep_check "^umask" /etc/bashrc 'umask 027'
  grep_check "^umask" /etc/profile 'umask 027'
  echo "Does the current wheel group look correct?"
  grep "wheel" /etc/group
}

securetty_changes(){
  echo "Secure tty list:"
  echo -e "console\ntty1\ntty2\ntty3\ntty4\ntty5\ntty6\n" > /etc/securetty
  echo "console tty1 tty2 tty3 tty4 tty5 tty6"
}

finds_main(){
  find_ww_dirs
  find_unowned_files_and_dirs
  find_ungrouped_files_and_dirs
  audit_suid_executables
  audit_sgid_executables
}

legacy_plus_entries_main(){
 for etc_file in group passwd shadow ; do
   legacy_plus_entries /etc/${etc_file}
 done
}

further_uid_and_passwd_checks_main(){
  echo "EXTENSIVE CHECKS SURROUNDING USERS:"
  root_uid_check
  root_path_check
  ensure_home_dirs_exist
  ensure_users_home_dirs_perms
  ensure_users_dot_files_perms
  ensure_no_dot_forwards
  ensure_no_netrcs
  ensure_netrcs_not_g_or_o_accessible
  ensure_no_rhosts_files
  ensure_all_groups_in_passwd_exist_in_group
  ensure_no_duplicate_IDs /etc/passwd
  ensure_no_duplicate_IDs /etc/group
  ensure_no_duplicate_names /etc/passwd
  ensure_no_duplicate_names /etc/group
}

properties_check_main(){
  create_local_fs_dir
  make_systemd_tmp
  edit_fstab_tmp "/tmp"
  edit_fstab_tmp "/var/tmp"
  edit_fstab_tmp "/dev/shm"
  edit_fstab_home "/home"
  remount_home "/home"
  remount_tmps "/tmp"
  remount_tmps "/var/tmp"
  remount_tmps "/dev/shm"
}

main(){
  date > hardening_report.${BACKUP}.txt
  yum_installations
  overwrite_issue
  fs_types_main
  partition_checks_main
  sticky_logic
  systemctl_disabling_main
  yum repolist
  yum_gpg_check_main
  superusr_check
  superpass_check
  single_user_auth_main
  restrict_kernel_parameters_main
  NX_is_active
  remove_prelink
  update_motd
  stat_file_and_remediate_main
  disable_services_main
  grep_check_main
  bring_down_wireless_ifs
  no_crondeny_or_cronallow
  pam_main
  properties_check_main
  nologin_sysaccounts
  usermod_changes     
  finds_main
  ./firewall_config.sh && echo "IPtables flushed and updated"
  securetty_changes
  lock_users_with_no_pass
  legacy_plus_entries_main
  further_uid_and_passwd_checks_main
  deny_hosts
  yum_removals
  restart_services_main
  echo "Scripts finished."
  echo "Please check hardening_report.txt" 
}

main 2>&1 | tee -a hardening_report.${BACKUP}.txt
