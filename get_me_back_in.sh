#!/bin/bash

# Quick utility to run post-hardening so the vagrant user can get back in the box via ssh

sed -i '/^ALL/d' /etc/hosts.deny
usermod -aG wheel vagrant
