echo "# INSTALL VAGRANT VM"

set -ex

HOM=/home/vagrant
CFG=$HOM/config
RES=$HOM/res
WRK=$HOM/work

BIN=$RES/sys/bin
LOC=$RES/sys/local_share
KEY=$RES/keys
SCR=$RES/scripts

# FIX: does not work
echo "## Setting Autologin (GUI)"
mkdir -p /etc/lightdm/lightdm.conf.d
echo "[SeatDefaults]\nautologin-user=vagrant" > /etc/lightdm/lightdm.conf.d/autologin.conf
systemctl restart lightdm

echo "## Setting Configs"

# echo -e "\n"                                          >> $PRF
# echo 'export EDITOR=hx'                               >> $PRF
# echo 'PATH=$PATH':$SCR:$BIN                           >> $PRF
# echo 'alias thm="sudo openvpn '$KEY'/tryhackme.ovpn"' >> $PRF
# echo 'alias tt="tmux -u new -A -s CTF-KALI"'          >> $PRF
# echo 'alias ts="tmux -u new -A -s CTF-KALI"'          >> $PRF
# echo "cd $WRK"                                        >> $PRF

# Auto link config folders
mkdir -p $HOM/.config
for config in $CFG/*; do
    if [ -d "$config" ]; then
        ln -sf "$config" "$HOM/.config/"
    fi
done

# Manual link config folders
# mkdir -p $HOM/.tmux
# ln -sf $CFG/tmux/.tmux.conf   $HOM/.tmux.conf
# ln -sf $CFG/tmux/themes       $HOM/.tmux/
# ln -sf $LOC/tmux/plugins      $HOM/.tmux/

mkdir -p $HOM/.local/share/fish/
ln -sf $LOC/fish_history $HOM/.local/share/fish/fish_history
ln -sf $LOC/tmux         $HOM/.local/share/
ln -sf $LOC/zsh_history  $HOM/.zsh_history


echo "## Installing Tools"

export DEBIAN_FRONTEND=noninteractive
apt-get update  -q

# Fish
apt-get install -yq fish
chsh -s /usr/bin/fish vagrant

echo "## Configs (fish)"
cat << EOF >> /etc/fish/config.fish
if status is-login
    set -gx EDITOR hx
    fish_add_path $SCR
    fish_add_path $BIN
    alias thm "sudo openvpn $KEY/tryhackme.ovpn"
    alias ttt="tmux -u new -A -s CTF-KALI"'
    # alias ts="tmux -u new -A -s CTF-KALI"'
    # alias ts="tmux -u new -A -s CTF-KALI"'
    # cd $WRK #causes tmux to loose path
end
EOF

# Tools
apt-get install -yq kitty  #alacritty
apt-get install -yq vim
apt-get install -yq vifm mc
apt-get install -yq gobuster
apt-get install -yq poppler-utils
apt-get install -yq python3-pylsp
apt-get install -yq clangd
apt-get install -yq p0f

# Network
for i in {1..10}; do
    ip addr del 10.44.44.$i/24 dev eth1 || true
done

ip addr add 10.44.44.44/24 dev eth1
ip route add 10.44.44.0/24 dev eth1 proto kernel scope link src 10.44.44.44 metric 100

echo "****************************************"
ip address show | grep "inet "
ip route
echo "****************************************"

