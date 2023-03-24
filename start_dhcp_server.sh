#!/usr/bin/env bash

VBoxManage dhcpserver add --network=hacking --server-ip=10.44.44.254 --lower-ip=10.44.44.1 --upper-ip=10.44.44.10 --netmask 255.255.255.0 --enable
