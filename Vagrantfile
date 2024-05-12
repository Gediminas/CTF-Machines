#!/usr/bin/env ruby

KALI_NAME = "ctf-kali"
KALI_BOX  = "kalilinux/rolling"
KALI_IP   = "10.44.44.44"
KALI_CPU  = 8
KALI_RAM  = 4096
INTRANET  = "hacking"

Vagrant.configure("2") do |kali|
  kali.vm.box              = KALI_BOX
  kali.vm.hostname         = KALI_NAME
  kali.vm.box_check_update = false  #update: `vagrant box outdated`, `vagrant box update`

  kali.vm.define KALI_NAME
  kali.vm.network "private_network", ip: KALI_IP, virtualbox__intnet: INTRANET

  kali.vm.synced_folder "../sync/.config",      "/home/vagrant/.config",       create: true, automount: true
  kali.vm.synced_folder "../sync/.local_share", "/home/vagrant/.local/share/", create: true, automount: true
  kali.vm.synced_folder "../sync",              "/home/vagrant/sync",          create: true, automount: true

  kali.vm.provider :virtualbox do |vbox|
    vbox.name   = KALI_NAME
    vbox.cpus   = KALI_CPU
    vbox.memory = KALI_RAM
    vbox.gui    = false

    vbox.customize ["modifyvm", :id, "--clipboard",          "bidirectional"]
    vbox.customize ["modifyvm", :id, "--draganddrop",        "bidirectional"]
    vbox.customize ["modifyvm", :id, "--vram",               "256"]
    vbox.customize ["modifyvm", :id, "--usb",                "on"]
  end

  kali.vm.provision :shell, :path => "scripts/install.sh"

  kali.vm.post_up_message = "'ctf-kali' is now running (user: vagrant, password: vagrant)"
end

