# -*- mode: ruby -*-
# vi: set ft=ruby :

# Run from cli to have files sync:
# vagrant rsync-auto

VAGRANTFILE_API_VERSION = "2"
HOSTNAME = "docker-env"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

if Vagrant.has_plugin?("vagrant-vbguest")
  config.vbguest.auto_update = false
end

  config.vm.define "agent1" do |agent1|
    agent1.vm.box = "centos/7"
    #agent1.vm.box = "alpine/alpine64"
    agent1.vm.hostname = "agent1"
    agent1.vm.provider :virtualbox do |vb|
      #vb.gui = true
      #vb.name = HOSTNAME
      vb.memory = 512
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--description", "jenkins agent"]
    end

    agent1.vm.network "private_network", ip: "192.168.200.201"
    agent1.vm.synced_folder "jenkins/agent", "/vagrant", type: "rsync", create: "true"
    agent1.vm.network "forwarded_port", guest: 22, host: 40022

    agent1.vm.provision "shell", inline: <<-SHELL
      cd /vagrant
      chmod +x *.sh
      sh setup.sh
    SHELL
  end

  config.vm.define "agent2" do |agent2|
    agent2.vm.box = "centos/7"
    #agent2.vm.box = "alpine/alpine64"
    agent2.vm.hostname = "agent2"
    agent2.vm.provider :virtualbox do |vb|
      #vb.gui = true
      #vb.name = HOSTNAME
      vb.memory = 512
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--description", "Jenkins agent"]
    end

    agent2.vm.network "private_network", ip: "192.168.200.202"
    agent2.vm.synced_folder "jenkins/agent", "/vagrant", type: "rsync", create: "true"
    agent2.vm.network "forwarded_port", guest: 22, host: 30022

    agent2.vm.provision "shell", inline: <<-SHELL
      cd /vagrant
      chmod +x *.sh
      sh setup.sh
    SHELL
  end

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "centos/7"
    #jenkins.vm.box = "alpine/alpine64"
    jenkins.vm.hostname = "jenkins"
    jenkins.vm.provider :virtualbox do |vb|
      #vb.gui = true
      #vb.name = HOSTNAME
      vb.memory = 512
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--description", "jenkins master"]
    end

    jenkins.vm.network "private_network", ip: "192.168.200.200"
    jenkins.vm.synced_folder "jenkins/jenkins", "/vagrant", type: "rsync", create: "true"
    jenkins.vm.network "forwarded_port", guest: 80, host: 50080
    # Main port
    jenkins.vm.network "forwarded_port", guest: 8080, host: 58080
    jenkins.vm.network "forwarded_port", guest: 443, host: 50443
    jenkins.vm.network "forwarded_port", guest: 22, host: 50022

    jenkins.vm.provision "shell", inline: <<-SHELL
      cd /vagrant
      chmod +x *.sh
      sh setup.sh
    SHELL

  end

  config.vm.define "postgresql" do |postgresql|
    postgresql.vm.box = "centos/7"
    #postgresql.vm.box = "alpine/alpine64"
    postgresql.vm.hostname = "postgresql"
    postgresql.vm.provider :virtualbox do |vb|
      #vb.gui = true
      #vb.name = HOSTNAME
      vb.memory = 512
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--description", "Postgre SQL DB"]
    end

    postgresql.vm.network "private_network", ip: "192.168.200.101"
    postgresql.vm.synced_folder "sonarqube/postgresql", "/vagrant", type: "rsync", create: "true"
    # Main port
    postgresql.vm.network "forwarded_port", guest: 5432, host: 5432
    postgresql.vm.provision "shell", inline: <<-SHELL
      cd /vagrant
      chmod +x *.sh
      sh setup.sh
    SHELL
  end

  config.vm.define "sonar" do |sonar|
    sonar.vm.box = "centos/7"
    #sonar.vm.box = "alpine/alpine64"
    sonar.vm.hostname = "sonar"
    sonar.vm.provider :virtualbox do |vb|
      #vb.gui = true
      #vb.name = HOSTNAME
      vb.memory = 1024
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--description", "SonarQube"]
    end

    sonar.vm.network "private_network", ip: "192.168.200.100"
    sonar.vm.synced_folder "sonarqube/sonarqube", "/vagrant", type: "rsync", create: "true"
    # Main port
    sonar.vm.network "forwarded_port", guest: 9000, host: 9000
    sonar.vm.provision "shell", inline: <<-SHELL
      cd /vagrant
      chmod +x *.sh
      sh setup.sh
    SHELL
  end

  config.vm.define "nexus" do |nexus|
    nexus.vm.box = "centos/7"
    #nexus.vm.box = "alpine/alpine64"
    nexus.vm.hostname = "nexus"
    nexus.vm.provider :virtualbox do |vb|
      #vb.gui = true
      #vb.name = HOSTNAME
      vb.memory = 512
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--description", "docker environment"]
    end

    nexus.vm.network "private_network", ip: "192.168.200.110"
    nexus.vm.synced_folder "nexus", "/vagrant", type: "rsync", create: "true"
    # Main port
    nexus.vm.network "forwarded_port", guest: 8081, host: 8081
    nexus.vm.provision "shell", inline: <<-SHELL
      cd /vagrant
      chmod +x *.sh
      sh setup.sh
    SHELL
  end


end

