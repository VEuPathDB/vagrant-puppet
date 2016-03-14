Vagrant.configure(2) do |config|

  config.vm.box = "ebrc/centos-7-64-puppet"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
    v.customize ["modifyvm", :id, "--ioapic", "on"]
#     v.gui = true
  end

  config.ssh.forward_agent = 'true'

#   if Vagrant.has_plugin?("vagrant-cachier")
#     # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
#     config.cache.scope = :machine
#     config.cache.enable :yum
#   end

  config.vm.network :private_network, type: 'dhcp'
  if Vagrant.has_plugin?('landrush')
    config.landrush.enabled = true
#    config.landrush.tld = ['vm.apidb.org', 'vm.toxodb.org']
    config.landrush.tld = 'vm.apidb.org'
  end
 
#  config.vm.hostname = 'sa.vm.apidb.org'
  config.vm.hostname = 'vm.apidb.org'

  if 1 == 1
    config.vm.provision :puppet do |puppet|
      #puppet.options = '--verbose --debug'
      #puppet.binary_path = '/opt/puppetlabs/bin'
      puppet.hiera_config_path = 'scratch/puppetlabs/code/hiera.yaml'
      puppet.environment_path = 'scratch/puppetlabs/code/environments'
      puppet.environment = 'hashicorp'
      # Can not specify specific manifest file,
      # https://github.com/mitchellh/vagrant/issues/6163
      # so using specific environment to setup PuppetDB
      # puppet.manifest_file = 'puppetdb_standalone.pp'
    end
  end

  # setup puppet structure
  # config.vm.synced_folder "scratch/puppetlabs/code/", "/etc/puppetlabs/code/", type: 'nfs'
  config.vm.synced_folder "scratch/puppetlabs/code/", "/etc/puppetlabs/code/", owner: "root", group: "root" 

end