# -*- mode: ruby -*-
# vi: set ft=ruby :

# vagrant rsync-auto

VAGRANTFILE_API_VERSION = "2"
HOSTNAME = "docker-env"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos/7"
  #config.vm.box = "alpine/alpine64"
  config.vm.hostname = HOSTNAME

  config.vm.provider :virtualbox do |vb|
    #vb.gui = true
    #vb.name = HOSTNAME
    vb.memory = 1024
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--description", "docker environment"]
  end

  config.vm.synced_folder ".", "/vagrant", type: "rsync", create: "true"
  config.vm.network "forwarded_port", guest: 80, host: 50080
  config.vm.network "forwarded_port", guest: 8080, host: 58080
  config.vm.network "forwarded_port", guest: 443, host: 50443

  config.vm.provision "shell", inline: <<-SHELL
    yum update -y
    yum install -y epel-release 
    yum install -y yum-utils jq net-tools
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum-config-manager --enable docker-ce-edge
    yum install -y docker-ce docker-compose docker-machine pip
    systemctl enable docker
    systemctl start docker
    usermod -aG docker vagrant
    cd /vagrant/cluster
    chmod +x /vagrant/cluster/*.sh
    sh /vagrant/cluster/01-start-cluster.sh
  SHELL

#  config.vm.provision "ansible" do |ansible|
#    ansible.compatibility_mode = "2.0"
#    ansible.playbook = "provisioning/main.yml"
#  end

end

