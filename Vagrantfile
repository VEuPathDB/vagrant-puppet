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
VAGRANT_MEMORY     = settings['VAGRANT_MEMORY']     || 8192
VAGRANT_HOSTNAME   = settings['VAGRANT_HOSTNAME']   || 'pup.apidb.org'
VAGRANT_SSHFORWARD = settings['VAGRANT_SSHFORWARD'] || 'true'
VAGRANT_DBDL       = settings['VAGRANT_DBDL']       || 'false'

Vagrant.configure(2) do |config|

  config.vm.box = "generic/rocky8"
  config.vm.network :private_network, type: 'dhcp'
  config.ssh.forward_agent = VAGRANT_SSHFORWARD
  #config.ssh.private_key_path = ["~/.ssh/id_rsa", "~/git/uga/vagrant-puppet/.vagrant/machines/default/libvirt/private_key"]

  # Libvirt settings
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = VAGRANT_CPUS
    libvirt.memory = VAGRANT_MEMORY

    # NFS: Make sure to enable UDP for NFSv3 on the host and set sudo rules:
    # https://developer.hashicorp.com/vagrant/docs/synced-folders/nfs#root-privilege-requirement
    config.vm.synced_folder ".", "/vagrant",type: "nfs",nfs_version: 4,nfs_udp: false
    config.vm.synced_folder "scratch/code/", "/etc/puppetlabs/code/",type: "nfs",nfs_version: 4,nfs_udp: false
    config.vm.synced_folder "r10k/", "/etc/puppetlabs/r10k/",type: "nfs",nfs_version: 4,nfs_udp: false
  end


  # Provisioning scripts
  config.vm.provision "shell", path: "addswap.sh"
  config.vm.provision "shell", path: "r10k.sh"
  config.vm.provision "shell", path: "bootstrap.sh"
  if VAGRANT_DBDL.eql? 'true'
    config.vm.provision "shell", path: "dbdl.sh"
  end

end
