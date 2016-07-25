VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true

  config.ssh.forward_agent = true

  config.vm.box = 'bento/ubuntu-16.04'
  config.vm.box_download_insecure = true

  config.vm.hostname = 'sembl.dev'
  config.vm.network 'private_network', ip: '172.17.145.2'

  config.vm.provision :ansible do |ansible|
    ansible.host_key_checking = false
    ansible.inventory_path = 'prov/vagrant'
    ansible.limit = 'all'
    ansible.playbook = 'prov/vagrant.yml'
  end

  config.vm.provider :virtualbox do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.synced_folder '.', '/vagrant', rsync: true # FIXME ideally this should be NFS
end
