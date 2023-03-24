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
  kali.vm.box_check_update = true  #update: `vagrant box outdated`, `vagrant box update`
  kali.vm.define KALI_NAME
  kali.vm.network "private_network", ip: KALI_IP, virtualbox__intnet: INTRANET

  # kali.vm.synced_folder "configs", "/home/vagrant/configs", create: true, automount: true
  kali.vm.synced_folder "../res",        "/home/vagrant/res",     create: true, automount: true
  kali.vm.synced_folder "../work",       "/home/vagrant/work",    create: true, automount: true

  kali.vm.provider :virtualbox do |vbox|
    vbox.name   = KALI_NAME
    vbox.cpus   = KALI_CPU
    vbox.memory = KALI_RAM

    # FIX: temp
    # vbox.gui    = true
    vbox.gui    = false

    vbox.customize ["modifyvm", :id, "--clipboard",          "bidirectional"]
    vbox.customize ["modifyvm", :id, "--draganddrop",        "bidirectional"]
    # disable remote display somehow
    # vbox.customize ["modifyvm", :id, "--graphicscontroller", "vboxsvga"]
    vbox.customize ["modifyvm", :id, "--graphicscontroller", "vboxsvga"]
    vbox.customize ["modifyvm", :id, "--vram",               "256"]
    vbox.customize ["modifyvm", :id, "--accelerate3d",       "on"]
    vbox.customize ["modifyvm", :id, "--monitorcount",       "1"]   
    vbox.customize ["modifyvm", :id, "--usb",                "on"]    
  end

  kali.vm.provision :shell, :path => "install.sh"

  kali.vm.post_up_message = "'ctf-kali' is now running (user: vagrant, password: vagrant)"

  # # Ansible
  # kali.vm.provision "ansible" do |ansible|
  #   ansible.playbook = "playbook-kali.yml"
  #   ansible.become = true
  #   ansible.become_user = "root"
  #   ansible.compatibility_mode = '2.0'
  #   ansible.extra_vars = { ansible_python_interpreter:"/usr/bin/python3" }
  # end

##################################################
#   kali.vm.provision "shell", inline: <<-SHELL
#     chsh -s /usr/bin/fish vagrant

#     # Install Rust
#     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

#     # Install Tide
#     /home/vagrant/.cargo/bin/cargo install tide   
#   SHELL

#   # Create a forwarded port mapping which allows access to a specific port
#   # within the machine from a port on the host machine. In the example below,
#   # accessing "localhost:8080" will access port 80 on the guest machine.
#   # NOTE: This will enable public access to the opened port
#   # config.vm.network "forwarded_port", guest: 80, host: 8080

#   # Create a forwarded port mapping which allows access to a specific port
#   # within the machine from a port on the host machine and only allow access
#   # via 127.0.0.1 to disable public access
#   # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

#   # Create a private network, which allows host-only access to the machine
#   # using a specific IP.
#   # config.vm.network "private_network", ip: "192.168.33.10"

end
