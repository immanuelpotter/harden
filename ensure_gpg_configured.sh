#!/bin/bash
ensure_gpg(){
  echo "Checking gpg-pubkey is installed..."
  gpg_results="$(rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n')"
  echo -e "GPG enforcement status: ${gpg_results}\nMake sure the package manager GPG keys are in accordance with site policy."
}
