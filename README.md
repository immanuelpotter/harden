 
 CIS Benchmark Standard CentOS 7 (v2.1.1)

 Server Level 1 Hardening scripts

 This has been designed to be idempotent; i.e. running more than once at any time will not cause problems.

Directions for use:

	1) Set your variables in variables.env. This is the first file sourced and will be acted upon by other called functions.

	2) Run main.sh as root to perform a full hardening run.

	3) Read the post-hardening report that can be found in same dir as this script, called hardening-report.txt. Please skim through this after running, as alerts which can't be changed via the script will be in here aswell as a full breakdown of amendments.

	4) Add a GRUB password yourself - instructions are in grub_passwd.sh

There are some areas that can't be scripted easily, such as adding superusers to GRUB - this will vary on different systems. Please check the hardening_report.txt and compare with what you were expecting, and if not, make manual changes. There won't be a password on grub for new installations, so you will have to make these changes yourself. Similarly, the list of users to apply expiration rules to in login_defs.sh will not be populated in variables.env at first, so will not be applied. By default, this script will follow the guidelines set out in CIS server hardening level 1, but if you wish to change the stringent account expiry rules, these are also found in variables.env.

Some requirements, such as "ensure syslog-ng OR rsyslog configured", offer some freedom - the easier/more default option will have been followed in these cases, so here would be rsyslog.

The finds.sh won't directly change permissions for you, but will alert you to any world-writable files or similar potentially problematic permissions. The same goes for further_uid_and_passwd_checks.sh. This is to stop dependencies breaking for your other applications, or unhappy users when you've globally changed their permissions. Again, please read the hardening_report.txt file. However, for fresh installs, they shouldn't produce much (if anything) at all.

These scripts automate a lot and provide a strong base to continue from, but it must be stressed again that manual changes should be made to grub and variables.env. It is worth reading main.sh to acquaint yourself with what is actually happening, and read the relevant sourced files as you need to.

PAM has also been configured not to deny after x accounts. This can be changed in pam_configuration.sh

If you want to add/remove kernel parameters as found in main.sh, these can be added directly to the relevant main method - this is another way to edit the script to your demands.

CHANGES YOU MAY WISH TO MAKE:

remove:
``` ALL: ALL```
 lines from /etc/hosts.deny OR add hosts to /etc/hosts.allow

Add users you want to be able to SSH in to a group, and put this group in /etc/ssh/sshd_config. Otherwise, post-harden, you won't be able to get back in the box.

vi /etc/ssh/sshd_config

	AllowGroups wheel

	usermod -aG wheel <user to ssh in as, "vagrant" if using vagrant>
