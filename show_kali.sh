#!/usr/bin/env bash

# vagrant ssh -c "export DISPLAY=:0.0; xset s off; xset s noblank; xset -dpms"

# VBoxManage controlvm ctf-kali setvideomodehint 1 1 0
VBoxManage startvm ctf-kali --type separate

# vagrant ssh -c "xfconf-query -c  xfce4-session -p /general/lock_on_suspend -n -t bool -s false"
# vagrant ssh -c "xfconf-query -c  xfce4-session -p /shutdown/LockScreen -n -t bool -s false"
