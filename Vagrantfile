# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load settings
require 'yaml'
settings_path = '.vagrant.yml'
settings = {}

if File.exist?(settings_path)
  settings = YAML.load_file(settings_path)
end

# Overrides and defaults
VAGRANT_CPUS       = settings['VAGRANT_CPUS']       || 4
VAGRANT_MEMORY     = settings['VAGRANT_MEMORY']     || 4096
VAGRANT_BOXURL     = settings['VAGRANT_BOXURL']     || 'http://software.apidb.org/vagrant/centos-7-64-puppet.json'
VAGRANT_BOX        = settings['VAGRANT_BOX']        || 'ebrc/centos-7-64-puppet'
VAGRANT_HOSTNAME   = settings['VAGRANT_HOSTNAME']   || 'pup.apidb.org'
VAGRANT_SSHFORWARD = settings['VAGRANT_SSHFORWARD'] || false
VAGRANT_DBDL       = settings['VAGRANT_DBDL']       || false

Vagrant.configure(2) do |config|

  config.vm.box_url = VAGRANT_BOXURL
  config.vm.box = VAGRANT_BOX
  config.vm.hostname = VAGRANT_HOSTNAME
  config.vm.network :private_network, type: 'dhcp'
  config.ssh.forward_agent = VAGRANT_SSHFORWARD

  # Libvirt settings
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = VAGRANT_CPUS
    libvirt.memory = VAGRANT_MEMORY

    # NFS: Make sure to enable UDP for NFSv3 on the host and set sudo rules:
    # https://developer.hashicorp.com/vagrant/docs/synced-folders/nfs#root-privilege-requirement
    config.vm.synced_folder ".", "/vagrant", type: "nfs"
    config.vm.synced_folder "scratch/code/", "/etc/puppetlabs/code/", type: "nfs"
    config.vm.synced_folder "r10k/", "/etc/puppetlabs/r10k/", type: "nfs"
  end

  # Virtualbox
  config.vm.provider :virtualbox do |vbox|
    vbox.cpus = VAGRANT_CPUS
    vbox.memory = VAGRANT_MEMORY
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]

    config.vm.synced_folder "scratch/code/", "/etc/puppetlabs/code/", owner: "root", group: "root"
    config.vm.synced_folder "r10k/", "/etc/puppetlabs/r10k/", owner: "root", group: "root"
  end

  # Provisioning scripts
  config.vm.provision "shell", path: "addswap.sh"
  config.vm.provision "shell", path: "r10k.sh"
  if VAGRANT_DBDL.eql? true
    config.vm.provision "shell", path: "dbdl.sh"
  end

end
