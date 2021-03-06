#!/bin/bash
export PATH=/opt/puppetlabs/bin:$PATH

# install python-pip
apt-get update
apt-get -y install python-pip

sed -i -e "s/nodaemon=true/nodaemon=false/" /etc/supervisord.conf
/usr/local/bin/supervisord -c /etc/supervisord.conf
echo "Running in $(pwd)"
echo "Puppet Version: $(puppet -V)"

# configure puppet
ln -sf $(pwd)/test/hiera.yaml $(puppet config print confdir |cut -d: -f1)/
curl -s https://gitlab.scale.sc/scalecommerce/postinstall/raw/master/puppet.conf > $(puppet config print confdir |cut -d: -f1)/puppet.conf
ln -sf $(pwd)/test/hieradata $(puppet config print confdir |cut -d: -f1)/hieradata
puppet config set certname puppet-test.scalecommerce

# install puppet modules
puppet module install ajcrowe-supervisord
puppet module install puppetlabs-apt --version 2.4.0
puppet module install puppet-gitlab --version 2.1.0
git clone https://github.com/ScaleCommerce/puppet-sc_supervisor.git /etc/puppet/modules/sc_supervisor
git clone https://github.com/ScaleCommerce/puppet-supervisor_provider.git $(puppet config print modulepath |cut -d: -f1)/supervisor_provider

ln -sf $(pwd) $(puppet config print modulepath |cut -d: -f1)/sc_gitlabrunner

#ln -sf ./test/document_roots /var/www
curl -s https://omnitruck.chef.io/install.sh | bash -s -- -P inspec  -v 3.9.3

#fix for scalecommerce/base:0.6
if ! dpkg-query -W apt-transport-https ; then
    apt-get update
    apt-get -y install --no-install-recommends apt-transport-https
fi
