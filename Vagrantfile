# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "backend" do |be|

    be.vm.box = "generic/ubuntu2204"
    be.vm.hostname = "backend.example.com"
    be.vm.post_up_message = "BACKEND VM UP"

    # to disable the automatic key insertion by Vagrant, specify multiple private key paths,
    # and provision the SSH public key to the ~/.ssh/authorized_keys file on the virtual machine.
    # be.ssh.insert_key=false
    # be.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa']
    # be.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys" 

    be.ssh.username = "vagrant"
    be.ssh.password = "vagrant"

    be.vm.network "private_network", type: 'static', ip: "192.168.121.221"
    be.vm.network "forwarded_port", guest: 8000, host: 8000

    # be.vm.provision "ansible" do |ansible|
    #   ansible.playbook = "playbook.yml"
    # end
    be.vm.provision "shell", path: "backend.sh"

    be.vm.provider "libvirt" do |lvt|
      lvt.cpus = 1
    end

  end

end

