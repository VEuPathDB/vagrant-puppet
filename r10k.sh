#!/bin/bash

setenforce 0
dnf -y module reset ruby
yum -y install @ruby:3.1
yum -y install ruby-devel
dnf -y install git wget
yum -y groupinstall "Development Tools"

gem install multipart-post -v 2.3.0
gem install semantic_puppet -v 1.1.0


echo ########################################################
echo #                 installing puppet agent              #
echo ########################################################

dnf -y update

#install puppet-agent
dnf -y install https://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm

dnf -y update

dnf -y install puppet-agent


#without this r10k fails to install
dnf -y install redhat-rpm-config
gem install r10k -v 4.0.0

# r10k not in path by default
if ! grep -q "export PATH=" /root/.bashrc; then
  echo "export PATH=\$PATH:/usr/local/bin" >> /root/.bashrc
fi

# Temporary fix for broken hiera on vm
GLOBAL_HIERA=/etc/puppetlabs/puppet/hiera.yaml
#sed -i '/  - common/{N; /\n  - users$/b; s/\n/\n  - users\n/}' $GLOBAL_HIERA
