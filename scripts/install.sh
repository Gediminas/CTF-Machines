#!/usr/bin/env bash

# set -ex
set -ueo pipefail

echo "****************************************"
echo "* Initializing"

PRF=/home/vagrant/.profile
WRK=/home/vagrant/sync/work
KEY=/home/vagrant/res/keys
BIN=/home/vagrant/sync/res/bin
SCR=/home/vagrant/sync/res/scripts

export DEBIAN_FRONTEND=noninteractive


# echo "****************************************"
# echo "* Setting GUI"

echo "* GUI: Enabling auto-login"
sed -i -e 's/#\s*autologin-user\s*=.*/autologin-user = vagrant/' /etc/lightdm/lightdm.conf || true
systemctl restart lightdm || true

# mkdir -p /etc/lightdm/lightdm.conf.d || true
# echo "[SeatDefaults]"         >> /etc/lightdm/lightdm.conf.d/50-autologin.conf || true
# echo "autologin-user=vagrant" >> /etc/lightdm/lightdm.conf.d/50-autologin.conf || true
# systemctl restart lightdm || true

# # # FIX: does not work
# # echo "## Setting Autologin (GUI)"
# # mkdir -p /etc/lightdm/lightdm.conf.d
# # echo "[SeatDefaults]\nautologin-user=vagrant" > /etc/lightdm/lightdm.conf.d/autologin.conf
# # systemctl restart lightdm


echo "* GUI: Disabling auto-lock"
# sed -i 's/\(<property name="lock_on_suspend" type="bool" value="\).*"\/>/\1false"\/>/' /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml || true
# sed -i 's/\(<property name="lock-screen-suspend-hibernate" type="bool" value="\).*"\/>/\1false"\/>/' /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml || true
# sed -i 's/\(<property name="lock-screen-switch-user" type="bool" value="\).*"\/>/\1false"\/>/' /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml || true

# systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# xfconf-query -c  xfce4-session -p /general/lock_on_suspend -n -t bool -s false || true
# xfconf-query -c  xfce4-session -p /shutdown/LockScreen     -n -t bool -s false || true

# gsettings set org.gnome.desktop.session idle-delay 0 || true
# systemd-inhibit sleep 20h || true

echo -e "\n"                                          >> $PRF
echo "export DISPLAY=:0.0; xset s off; xset s noblank; xset -dpms" >> $PRF
# echo "export DISPLAY=:0.0; xset s off; xset s noblank" >> $PRF

# echo "****************************************"
echo "* Setting Bash / Zsh"

echo "* Setting Configs"
echo -e "\n"                                          >> $PRF
echo 'export EDITOR=hx'                               >> $PRF
echo 'PATH=$PATH':$SCR:$BIN                           >> $PRF
echo 'alias thm="sudo openvpn '$KEY'/tryhackme.ovpn"' >> $PRF
echo 'alias tt="tmux -u new -A -s CTF-KALI"'          >> $PRF
echo 'alias ts="tmux -u new -A -s CTF-KALI"'          >> $PRF
echo "cd $WRK"                                        >> $PRF


# echo "****************************************"
echo "* Updating"

apt-get -qq update > /dev/null


# echo "****************************************"
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


# echo "****************************************"
echo "* Installing Tools"

set -x
apt-get install -qq vifm          > /dev/null
apt-get install -qq mc            > /dev/null
apt-get install -qq gobuster      > /dev/null
apt-get install -qq poppler-utils > /dev/null
apt-get install -qq python3-pylsp > /dev/null
apt-get install -qq clangd        > /dev/null
apt-get install -qq p0f           > /dev/null
apt-get install -qq zaproxy       > /dev/null
set +x


# echo "****************************************"
echo "* Setting Network"

# Network
for i in {1..20}; do
    ip addr del 10.44.44.$i/24 dev eth1  2> /dev/null || true
done

# echo add
ip addr add 10.44.44.44/24 dev eth1 || true
ip route add 10.44.44.0/24 dev eth1 proto kernel scope link src 10.44.44.44 metric 100 || true

# echo "* Fixing IP"
# dhclient eth1 -r -v
# ifdown eth1 -v
# ifup eth1 -v

echo "* Finished"

export DEBIAN_FRONTEND=

echo "****************************************"
echo "IPs:"
ip address show | grep "inet "
echo "ROUTES:"
ip route
echo "****************************************"
