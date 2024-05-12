#!/usr/bin/env bash

##########################################
echo "****************************************"
echo "* Post install"

set -ueo pipefail

export DEBIAN_FRONTEND=noninteractive


##########################################
echo "* Installing/Updating data files (worklists, payloads, etc)"

mkdir -p /home/vagrant/sync/res/data/
cd /home/vagrant/sync/res/data/

if [ ! -d ./PayloadsAllTheThings ]; then
    git clone https://github.com/swisskyrepo/PayloadsAllTheThings PayloadsAllTheThings
    ln -s /usr/share/PayloadsAllTheThings PayloadsAllTheThings
else
    cd PayloadsAllTheThings
    git pull
    cd /home/vagrant/sync/res/data/
fi

if [ ! -d ./SecLists ]; then
    git clone https://github.com/TH3xACE/SecLists SecLists
    ln -s /usr/share/SecLists SecLists
else
    cd SecLists
    git pull
    cd /home/vagrant/sync/res/data/
fi

# - name: Privilege escalation tools
#   hosts: all
#   remote_user: vagrant
#   vars:
#     priv_esc_dir: "/usr/share/PrivEsc"
#   - name: LinEnum
#      repo: https://github.com/rebootuser/LinEnum 
#   - name: Lin Exploit suggester 
#      repo: https://github.com/mzet-/linux-exploit-suggester 
#   - name: PEAS
#      repo: https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite
#   - name: pspy 
#      repo: https://github.com/DominicBreuker/pspy


##########################################
echo "* Finish"

export DEBIAN_FRONTEND=
