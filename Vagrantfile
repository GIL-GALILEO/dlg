Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 8983, host: 3983
  config.vm.network :private_network, ip: '192.168.50.50'
  config.vm.synced_folder '.', '/opt/dlg', nfs: true
  config.vm.provider :virtualbox do |v, _|
    v.memory = 1024
  end
  config.vm.provision 'shell', inline: <<-SHELL
    sudo date > /etc/vagrant_provisioned_at
    # basic
    add-apt-repository ppa:webupd8team/java
    apt-get update
    apt-get upgrade
    apt-get -y -q install git-core nodejs libpq-dev
  SHELL
  config.vm.provision :shell, path: 'provision/install_rvm.sh', args: 'stable', name: 'RVM'
  config.vm.provision :shell, path: 'provision/install_ruby.sh', args: '2.3.4', name: 'Ruby'
  config.vm.provision :shell, path: 'provision/postgres.sh', name: 'PG'
  config.vm.provision :shell, path: 'provision/solr.sh', name: 'Solr'
  config.vm.provision :shell, path: 'provision/dlg.sh', name: 'DLG App', privileged: false
end