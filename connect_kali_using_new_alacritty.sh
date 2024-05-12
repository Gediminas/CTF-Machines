#!/usr/bin/env bash

# alacritty --command vagrant ssh --command "tmux -u new -A -s CTF-KALI" &
alacritty --command ./connect_kali.sh &
