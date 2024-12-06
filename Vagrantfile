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
VAGRANT_BOXURL     = settings['VAGRANT_BOXURL']     || ''
VAGRANT_BOX        = settings['VAGRANT_BOX']        || 'VEuPathDB/rocky9-64-puppet'
VAGRANT_HOSTNAME   = settings['VAGRANT_HOSTNAME']   || 'pup.apidb.org'
VAGRANT_SSHFORWARD = settings['VAGRANT_SSHFORWARD'] || false
VAGRANT_SSH_PORT   = settings['VAGRANT_SSH_PORT']   || 22
VAGRANT_DBDL       = settings['VAGRANT_DBDL']       || false
VAGRANT_RUN_CUSTOM = settings['VAGRANT_RUN_CUSTOM'] || 'never'
VAGRANT_USE_VIRTIOFS = settings['VAGRANT_USE_VIRTIOFS'] || false

Vagrant.configure(2) do |config|

  config.vm.box_url = VAGRANT_BOXURL unless VAGRANT_BOXURL.empty?
  config.vm.box = VAGRANT_BOX
  config.vm.hostname = VAGRANT_HOSTNAME
  config.vm.network :private_network, type: 'dhcp'
  config.ssh.forward_agent = VAGRANT_SSHFORWARD
  config.ssh.port = VAGRANT_SSH_PORT

  # Libvirt settings
  config.vm.provider :libvirt do |libvirt, override|
    libvirt.cpus = VAGRANT_CPUS
    libvirt.memory = VAGRANT_MEMORY

    if VAGRANT_USE_VIRTIOFS.eql? true
      libvirt.memorybacking :access, :mode => "shared"
      libvirt.memorybacking :source, :type => "memfd"
    end

    synced_folder_type = VAGRANT_USE_VIRTIOFS ? "virtiofs" : "nfs"

    # NFS: Make sure to enable UDP for NFSv3 on the host and set sudo rules:
    # https://developer.hashicorp.com/vagrant/docs/synced-folders/nfs#root-privilege-requirement
    #
    # VIRTIOFS: make sure you have virtiofsd installed on the host and you configured shared memory
    # setting for libvirt
    # https://vagrant-libvirt.github.io/vagrant-libvirt/examples.html#synced-folders
    override.vm.synced_folder ".", "/vagrant", type: synced_folder_type
    override.vm.synced_folder "scratch/code", "/etc/puppetlabs/code/", type: synced_folder_type
    override.vm.synced_folder "../puppet-control", "/vagrant/scratch/puppet-control", type: synced_folder_type
    override.vm.synced_folder "../puppet-profiles", "/vagrant/scratch/puppet-profiles", type: synced_folder_type
    override.vm.synced_folder "../puppet-roles", "/vagrant/scratch/puppet-roles", type: synced_folder_type
    override.vm.synced_folder "../puppet-hiera", "/vagrant/scratch/puppet-hiera", type: synced_folder_type
    override.vm.synced_folder "../puppet-ebrc_packages", "/vagrant/scratch/puppet-ebrc_packages", type: synced_folder_type
    override.vm.synced_folder "../puppet-iscsi", "/vagrant/scratch/puppet-iscsi", type: synced_folder_type
    override.vm.synced_folder "../puppet-authorized_keys", "/vagrant/scratch/puppet-authorized_keys", type: synced_folder_type
    override.vm.synced_folder "../puppet-users", "/vagrant/scratch/puppet-users", type: synced_folder_type
  end

  # Virtualbox
  config.vm.provider :virtualbox do |vbox, override|
    vbox.cpus = VAGRANT_CPUS
    vbox.memory = VAGRANT_MEMORY
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]

    override.vm.synced_folder "scratch/code/", "/etc/puppetlabs/code/", owner: "root", group: "root"
  end

  # Provisioning scripts
  config.vm.provision "shell", path: "addswap.sh"
  if VAGRANT_DBDL.eql? true
    config.vm.provision "shell", path: "dbdl.sh"
  end

  # Run custom scripts
  config.vm.provision "shell", run: VAGRANT_RUN_CUSTOM, inline: <<-SHELL
    for script in /vagrant/scratch/scripts/*; do
      [ -x "$script" ] && $script
    done
  SHELL

end
