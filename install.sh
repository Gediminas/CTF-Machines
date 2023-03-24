echo "# INSTALL VAGRANT VM"

set -x

HOM=/home/vagrant
BIN=$HOM/res/bin
CFG=$HOM/res/cfg
KEY=$HOM/res/keys
SCR=$HOM/res/scripts
WRK=$HOM/work

# FIX: does not work
echo "## Setting Autologin (GUI)"
mkdir -p /etc/lightdm/lightdm.conf.d
echo "[SeatDefaults]\nautologin-user=vagrant" > /etc/lightdm/lightdm.conf.d/autologin.conf
systemctl restart lightdm

echo "## Setting Configs"

echo -e "\n"                                          >> $PRF
echo 'export EDITOR=hx'                               >> $PRF
echo 'PATH=$PATH':$SCR:$BIN                           >> $PRF
echo 'alias thm="sudo openvpn '$KEY'/tryhackme.ovpn"' >> $PRF
echo "cd $WRK"                                        >> $PRF

mkdir -p $HOM/.config
ln -sf $CFG/config/fish              $HOM/.config/
ln -sf $CFG/config/helix             $HOM/.config/
ln -sf $CFG/config/kitty             $HOM/.config/
ln -sf $CFG/config/nvim              $HOM/.config/
ln -sf $CFG/config/vifm              $HOM/.config/
ln -sf $CFG/config/vim               $HOM/.config/

mkdir -p $HOM/.tmux
ln -sf $CFG/config/tmux/themes       $HOM/.tmux/
ln -sf $CFG/config/tmux/plugins      $HOM/.tmux/
ln -sf $CFG/config/tmux/.tmux.conf   $HOM/.tmux.conf

mkdir -p $HOM/.local/share/fish/
ln -sf $CFG/local_share/fish_history $HOM/.local/share/fish/fish_history

ln -sf $CFG/local_share/tmux         $HOM/.local/share/
ln -sf $CFG/local_share/zsh_history  $HOM/.zsh_history


echo "## Setting Aliases"

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
    cd $WRK
end
EOF

# Tools
apt-get install -yq kitty  #alacritty
apt-get install -yq vim neovim
apt-get install -yq vifm mc
apt-get install -yq gobuster
apt-get install -yq poppler-utils
apt-get install -yq python3-pylsp
apt-get install -yq clangd

