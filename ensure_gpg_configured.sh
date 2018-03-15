#!/bin/bash
ensure_gpg(){
  echo "Checking gpg-pubkey is installed..."
  gpg_results="$(rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n' | tee -a hardening_results.txt)"
  echo "Make sure the package manager GPG keys are in accordance with site policy." | tee -a hardening_results.txt 
}
