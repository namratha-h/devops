# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
    config.vm.define "frontend" do |fe|
  
      fe.vm.box = "generic/ubuntu2204"
      fe.vm.hostname = "frontend.example.com"
      fe.vm.post_up_message = "FRONTEND VM UP"
  
      fe.vm.network "private_network", type: "static", ip: "192.168.121.220"
      fe.vm.network "forwarded_port", guest: 3000, host: 3000

      fe.vm.synced_folder ".", "/frontend"
  
      fe.vm.provision "shell", path: "frontend.sh"
  
      fe.vm.provider "libvirt" do |lvt|
        lvt.qemu_use_session = false
        lvt.cpus = 1
      end
  
    end
  
  end
  