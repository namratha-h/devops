Vagrant.configure("2") do |config|
    config.vm.define "database" do |db|
        db.vm.box = "generic/ubuntu2204"
        db.vm.hostname = "database.example.com"
        db.vm.post_up_message = "Database VM UP"

        db.vm.network "private_network", type: "static", ip: "192.168.121.222";

        db.vm.provision "shell", path: "script.sh";
        
        db.vm.provider "libvirt" do |lvt|
            lvt.qemu_use_session = false
            lvt.cpus = 1
        end

    end
end
