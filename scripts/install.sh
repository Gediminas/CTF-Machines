#!/usr/bin/env bash

##########################################
echo "****************************************"
echo "* Initializing"

set -ueo pipefail

WRK=/home/vagrant/sync/work
KEY=/home/vagrant/res/keys
BIN=/home/vagrant/sync/res/bin
SCR=/home/vagrant/sync/res/scripts

export DEBIAN_FRONTEND=noninteractive


##########################################
echo "* GUI: Enabling auto-login"

sed -i -e 's/#\s*autologin-user\s*=.*/autologin-user = vagrant/' /etc/lightdm/lightdm.conf || true
systemctl restart lightdm || true


##########################################
echo "* Setting .profile"
cat << EOF >> /home/vagrant/.profile
if status is-login
  # disable auto-lock
  export DISPLAY=:0.0
  xset s off
  xset s noblank
  xset -dpms

  alias thm="sudo openvpn '$KEY'/tryhackme.ovpn"
  alias tt="tmux -u new -A -s CTF-KALI"
  alias ts="tmux -u new -A -s CTF-KALI"

  export EDITOR=hx
  PATH=$PATH:$SCR:$BIN
  cd $WRK"
end
EOF


##########################################
echo "* Updating"

apt-get -qq update > /dev/null


##########################################
echo "* Installing Fish"

apt-get install -qq fish > /dev/null

chsh -s /usr/bin/fish vagrant

cat << EOF >> /etc/fish/config.fish
if status is-login
    set -gx EDITOR hx
    fish_add_path $SCR
    fish_add_path $BIN
    alias thm "sudo openvpn $KEY/tryhackme.ovpn"
    alias ttt="tmux -u new -A -s CTF-KALI"
    cd $WRK #causes tmux to loose path
end
EOF


##########################################
echo "* Installing Tools"

set -x
apt-get install -qq vifm          > /dev/null
apt-get install -qq mc            > /dev/null
apt-get install -qq gobuster      > /dev/null
apt-get install -qq poppler-utils > /dev/null  #pdf
apt-get install -qq python3-pylsp > /dev/null
apt-get install -qq clangd        > /dev/null
apt-get install -qq p0f           > /dev/null
apt-get install -qq zaproxy       > /dev/null
set +x


##########################################
echo "* Set static IP"

for i in {1..20}; do
    ip addr del 10.44.44.$i/24 dev eth1  2> /dev/null || true
done

ip addr add 10.44.44.44/24 dev eth1 || true
ip route add 10.44.44.0/24 dev eth1 proto kernel scope link src 10.44.44.44 metric 100 || true

##########################################
echo "* Finish"

export DEBIAN_FRONTEND=

echo "****************************************"
echo "IPs:"
ip address show | grep "inet "
echo "ROUTES:"
ip route
echo "****************************************"
