require 'beaker/platform'
require 'spec_helper'

module Beaker
  describe Vagrant do
    let(:options) do
      make_opts.merge({
                        'logger' => double.as_null_object,
                        :hosts_file => 'sample.cfg',
                        :forward_ssh_agent => true,
                      })
    end

    let(:vagrant) { Beaker::Vagrant.new(@hosts, options) }

    before do
      @hosts = make_hosts({
                            mount_folders: {
                              test_temp: { from: './', to: '/temp' },
                              test_tmp: { from: '../', to: '/tmp' },
                            },
                            forwarded_ports: {
                              http: { from: 10_080, to: 80 },
                              ssl: { from: 4443, to: 443 },
                              tomcat: { from: 8080, to: 8080 },
                            },
                            platform: Beaker::Platform.new('centos-8-x86_64'),
                          })
    end

    it 'stores the vagrant file in $WORKINGDIR/.vagrant/beaker_vagrant_files/beaker_sample.cfg' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      expect(path).to be === File.join(Dir.pwd, '.vagrant', 'beaker_vagrant_files', 'beaker_sample.cfg')
    end

    it 'can make a Vagrantfile for a set of hosts' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      vagrant.make_vfile(@hosts)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      puts "file is #{path}\n"
      expect(vagrantfile).to be === <<~EOF
        Vagrant.configure("2") do |c|
          c.ssh.insert_key = false
          c.vm.define 'vm1' do |v|
            v.vm.hostname = 'vm1'
            v.vm.box = 'vm2vm1_of_my_box'
            v.vm.box_url = 'http://address.for.my.box.vm1'
            v.vm.box_check_update = 'true'
            v.vm.network :private_network, ip: "ip.address.for.vm1", :netmask => "255.255.0.0"
            v.vm.synced_folder './', '/temp', create: true
            v.vm.synced_folder '../', '/tmp', create: true
            v.vm.network :forwarded_port, guest: 80, host: 10080
            v.vm.network :forwarded_port, guest: 443, host: 4443
            v.vm.network :forwarded_port, guest: 8080, host: 8080
            v.vm.provider :virtualbox do |vb|
              vb.customize ['modifyvm', :id, '--memory', '2048', '--cpus', '2', '--audio', 'none']
            end
          end
          c.vm.define 'vm2' do |v|
            v.vm.hostname = 'vm2'
            v.vm.box = 'vm2vm2_of_my_box'
            v.vm.box_url = 'http://address.for.my.box.vm2'
            v.vm.box_check_update = 'true'
            v.vm.network :private_network, ip: "ip.address.for.vm2", :netmask => "255.255.0.0"
            v.vm.synced_folder './', '/temp', create: true
            v.vm.synced_folder '../', '/tmp', create: true
            v.vm.network :forwarded_port, guest: 80, host: 10080
            v.vm.network :forwarded_port, guest: 443, host: 4443
            v.vm.network :forwarded_port, guest: 8080, host: 8080
            v.vm.provider :virtualbox do |vb|
              vb.customize ['modifyvm', :id, '--memory', '2048', '--cpus', '2', '--audio', 'none']
            end
          end
          c.vm.define 'vm3' do |v|
            v.vm.hostname = 'vm3'
            v.vm.box = 'vm2vm3_of_my_box'
            v.vm.box_url = 'http://address.for.my.box.vm3'
            v.vm.box_check_update = 'true'
            v.vm.network :private_network, ip: "ip.address.for.vm3", :netmask => "255.255.0.0"
            v.vm.synced_folder './', '/temp', create: true
            v.vm.synced_folder '../', '/tmp', create: true
            v.vm.network :forwarded_port, guest: 80, host: 10080
            v.vm.network :forwarded_port, guest: 443, host: 4443
            v.vm.network :forwarded_port, guest: 8080, host: 8080
            v.vm.provider :virtualbox do |vb|
              vb.customize ['modifyvm', :id, '--memory', '2048', '--cpus', '2', '--audio', 'none']
            end
          end
        end
      EOF
    end

    it 'can make a Vagrantfile with ssh agent forwarding enabled' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      hosts = make_hosts({}, 1)
      vagrant.make_vfile(hosts, options)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      expect(vagrantfile).to match(/(ssh.forward_agent = true)/)
    end

    it 'can make a Vagrantfile with ssh timeout' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      hosts = make_hosts({ ssh_keep_alive: true }, 1)
      vagrant.make_vfile(hosts, options)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      expect(vagrantfile).to match(/(ssh.keep_alive = true)/)
    end

    it 'can replace underscores in host.name with hypens' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      host = make_host('name-with_underscore', {})
      vagrant.make_vfile([host], options)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      expect(vagrantfile).to match(/v.vm.hostname = .*name-with-underscore/)
    end

    it 'can make a Vagrantfile with synced_folder disabled' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      hosts = make_hosts({ synced_folder: 'disabled' }, 1)
      vagrant.make_vfile(hosts, options)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      expect(vagrantfile).to match(/v.vm.synced_folder .* disabled: true/)
    end

    it 'can make a Vagrantfile with network mac specified' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      hosts = make_hosts({ network_mac: 'b6:33:ae:19:48:f9' }, 1)
      vagrant.make_vfile(hosts, options)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      expect(vagrantfile).to match(/v.vm.network :private_network, ip: "ip.address.for.vm1", :netmask => "255.255.0.0", :mac => "b6:33:ae:19:48:f9/)
    end

    it 'can make a Vagrantfile with improper keys for synced folders' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      hosts = make_hosts({ mount_folders: {
                           test_invalid1: { host_path: '/invalid1', container_path: '/invalid1' },
                           test_invalid2: { from: '/invalid2', container_path: '/invalid2' },
                           test_invalid3: { host_path: '/invalid3', to: '/invalid3' },
                           test_valid: { from: '/valid', to: '/valid' },
                         } }, 1)
      vagrant.make_vfile(hosts, options)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))

      expect(vagrantfile).not_to match(/v.vm.synced_folder '', '', create: true/)
      expect(vagrantfile).not_to match(%r{v.vm.synced_folder '/invalid2', '', create: true})
      expect(vagrantfile).not_to match(%r{v.vm.synced_folder '', '/invalid3', create: true})
      expect(vagrantfile).to match(%r{v.vm.synced_folder '/valid', '/valid', create: true})
    end

    it 'can make a Vagrantfile with optional shell provisioner' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      shell_path = '/path/to/shell/script'
      hosts = make_hosts({
                           shell_provisioner: {
                             path: shell_path,
                           },
                         }, 1)
      vagrant.make_vfile(hosts, options)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      expect(vagrantfile).to match(/v.vm.provision 'shell', :path => '#{shell_path}'/)
    end

    it 'can make a Vagrantfile with optional shell provisioner with args' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      shell_path = '/path/to/shell/script.sh'
      shell_args = 'arg1 arg2'
      hosts = make_hosts({
                           shell_provisioner: {
                             path: shell_path,
                             args: shell_args,
                           },
                         }, 1)
      vagrant.make_vfile(hosts, options)

      vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      expect(vagrantfile).to match(/v.vm.provision 'shell', :path => '#{shell_path}', :args => '#{shell_args}'/)
    end

    it 'raises an error if path is not set on shell_provisioner' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      hosts = make_hosts({ shell_provisioner: {} }, 1)
      expect do
        vagrant.make_vfile(hosts, options)
      end.to raise_error RuntimeError, /No path defined for shell_provisioner or path empty/
    end

    it 'raises an error if path is EMPTY on shell_provisioner' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      empty_shell_path = ''
      hosts = make_hosts({
                           shell_provisioner: {
                             path: empty_shell_path,
                           },
                         }, 1)
      expect do
        vagrant.make_vfile(hosts, options)
      end.to raise_error RuntimeError, /No path defined for shell_provisioner or path empty/
    end

    context 'when generating a windows config' do
      before do
        path = vagrant.instance_variable_get(:@vagrant_path)
        @hosts[0][:platform] = 'windows'

        vagrant.make_vfile(@hosts)

        @generated_file = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      end

      it 'has the proper port forwarding for RDP' do
        expect(@generated_file).to match(/v.vm.network :forwarded_port, guest: 3389, host: 3389, id: 'rdp', auto_correct: true/)
      end

      it 'has the proper port forwarding for WinRM' do
        expect(@generated_file).to match(/v.vm.network :forwarded_port, guest: 5985, host: 5985, id: 'winrm', auto_correct: true/)
      end

      it 'configures the guest type to windows' do
        expect(@generated_file).to match(/v.vm.guest = :windows/)
      end

      it 'configures the guest type to use winrm' do
        expect(@generated_file).to match(/v.vm.communicator = 'winrm'/)
      end

      it 'sets a non-default memsize' do
        expect(@generated_file).to match(/'--memory', '2048',/)
      end
    end

    context 'when generating a freebsd config' do
      before do
        path = vagrant.instance_variable_get(:@vagrant_path)
        @hosts[0][:platform] = 'freebsd'

        vagrant.make_vfile(@hosts)

        @generated_file = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
      end

      it 'has the proper ssh shell' do
        expect(@generated_file).to match(/v.ssh.shell = 'sh'\n/)
      end

      it 'has the proper guest setting' do
        expect(@generated_file).to match(/v.vm.guest = :freebsd\n/)
      end
    end

    it 'uses the memsize defined per vagrant host' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      vagrant.make_vfile(@hosts, { 'vagrant_memsize' => 'hello!' })

      generated_file = File.read(File.expand_path(File.join(path, 'Vagrantfile')))

      match = generated_file.match(/vb.customize \['modifyvm', :id, '--memory', 'hello!', '--cpus', '2', '--audio', 'none'\]/)

      expect(match).not_to be_nil
    end

    it 'uses the cpus defined per vagrant host' do
      path = vagrant.instance_variable_get(:@vagrant_path)

      vagrant.make_vfile(@hosts, { 'vagrant_cpus' => 'goodbye!' })

      generated_file = File.read(File.expand_path(File.join(path, 'Vagrantfile')))

      match = generated_file.match(/vb.customize \['modifyvm', :id, '--memory', '2048', '--cpus', 'goodbye!', '--audio', 'none'\]/)

      expect(match).not_to be_nil
    end

    context 'port forwarding rules' do
      it 'supports all Vagrant parameters' do
        path = vagrant.instance_variable_get(:@vagrant_path)

        hosts = make_hosts(
          {
            forwarded_ports: {
              http: {
                from: 10_080,
                from_ip: '127.0.0.1',
                to: 80,
                to_ip: '0.0.0.0',
                protocol: 'udp',
              },
            },
          }, 1
        )
        vagrant.make_vfile(hosts, options)

        vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
        expect(vagrantfile).to match(/v.vm.network :forwarded_port, protocol: 'udp', guest_ip: '0.0.0.0', guest: 80, host_ip: '127.0.0.1', host: 10080/)
      end

      it 'supports supports from_ip' do
        path = vagrant.instance_variable_get(:@vagrant_path)

        hosts = make_hosts(
          {
            forwarded_ports: {
              http: {
                from: 10_080,
                from_ip: '127.0.0.1',
                to: 80,
              },
            },
          }, 1
        )
        vagrant.make_vfile(hosts, options)

        vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
        expect(vagrantfile).to match(/v.vm.network :forwarded_port, guest: 80, host_ip: '127.0.0.1', host: 10080/)
      end

      it 'supports all to_ip' do
        path = vagrant.instance_variable_get(:@vagrant_path)

        hosts = make_hosts(
          {
            forwarded_ports: {
              http: {
                from: 10_080,
                to: 80,
                to_ip: '0.0.0.0',
              },
            },
          }, 1
        )
        vagrant.make_vfile(hosts, options)

        vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
        expect(vagrantfile).to match(/v.vm.network :forwarded_port, guest_ip: '0.0.0.0', guest: 80, host: 10080/)
      end

      it 'supports all protocol' do
        path = vagrant.instance_variable_get(:@vagrant_path)

        hosts = make_hosts(
          {
            forwarded_ports: {
              http: {
                from: 10_080,
                to: 80,
                protocol: 'udp',
              },
            },
          }, 1
        )
        vagrant.make_vfile(hosts, options)

        vagrantfile = File.read(File.expand_path(File.join(path, 'Vagrantfile')))
        expect(vagrantfile).to match(/v.vm.network :forwarded_port, protocol: 'udp', guest: 80, host: 10080/)
      end
    end

    it 'can generate a new /etc/hosts file referencing each host' do
      @hosts.each do |host|
        expect(vagrant).to receive(:get_domain_name).with(host).and_return('labs.lan')
        expect(vagrant).to receive(:set_etc_hosts).with(host,
                                                        "127.0.0.1\tlocalhost localhost.localdomain\nip.address.for.vm1\tvm1.labs.lan vm1\nip.address.for.vm2\tvm2.labs.lan vm2\nip.address.for.vm3\tvm3.labs.lan vm3\n").once
      end

      vagrant.hack_etc_hosts(@hosts, options)
    end

    context "can copy vagrant's key to root .ssh on each host" do
      it 'can copy to root on unix' do
        host = @hosts[0]
        host[:platform] = 'unix'

        expect(Command).to receive(:new).with('sudo su -c "cp -r .ssh /root/."').once
        expect(Command).to receive(:new).with('sudo fixfiles restore /root').once
        expect(Command).to receive(:new).with('sudo selinuxenabled').once

        vagrant.copy_ssh_to_root(host, options)
      end

      it 'can copy to Administrator on windows' do
        host = @hosts[0]
        host[:platform] = 'windows'
        expect(host).to receive(:is_cygwin?).and_return(true)

        expect(Command).not_to receive(:new).with('sudo fixfiles restore /root')
        expect(Command).to receive(:new).with('cp -r .ssh /cygdrive/c/Users/Administrator/.').once
        expect(Command).to receive(:new).with('chown -R Administrator /cygdrive/c/Users/Administrator/.ssh').once

        # This is checked on all platforms since Linux isn't called out specifically in the code
        # If this fails, nothing further is activated
        result = Beaker::Result.new(host, '')
        result.exit_code = 1
        expect(Command).to receive(:new).with('sudo selinuxenabled')
        allow(host).to receive(:exec).and_return(result)

        vagrant.copy_ssh_to_root(host, options)
      end
    end

    describe 'set_ssh_config' do
      let(:out) do
        <<-CONFIG
        Host #{name}
          HostName 127.0.0.1
          User vagrant
          Port 2222
          UserKnownHostsFile /dev/null
          StrictHostKeyChecking no
          PasswordAuthentication no
          IdentityFile /home/root/.vagrant.d/insecure_private_key
          IdentitiesOnly yes
        CONFIG
      end
      let(:host) { @hosts[0] }
      let(:name) { host.name }
      let(:override_options) { {} }

      before do
        # FakeFS is just broken with Tempfile
        FakeFS.deactivate!
        Dir.mktmpdir do |dir|
          vagrant.instance_variable_get(:@options).merge!(override_options)
          vagrant.instance_variable_set(:@vagrant_path, dir)
          state = double('state')
          allow(state).to receive(:success?).and_return(true)
          allow(Open3).to receive(:capture3).with({}, 'vagrant', 'ssh-config', name).and_return([out, '', state])

          vagrant.set_ssh_config(host, 'root')
        end
      end

      it 'sets the user to root' do
        expect(host['user']).to be === 'root'
      end

      it 'sets the ssh user to root' do
        expect(host['ssh']['user']).to be === 'root'
      end

      # This is because forward_ssh_agent is true by default
      it 'sets IdentitiesOnly to no' do
        expect(host['ssh'][:keys_only]).to be === false
      end

      context 'when :forward_ssh_agent is false' do
        let(:override_options) do
          { forward_ssh_agent: false }
        end

        it 'keeps IdentitiesOnly to yes' do
          expect(host['ssh'][:keys_only]).to be === true
        end
      end
    end

    context 'with options[:provision] = false' do
      let(:options) { super().merge(provision: false) }

      context 'when Vagrantfile does not exist' do
        it 'raises an error' do
          expect { vagrant.configure }.to raise_error RuntimeError, /no vagrant file was found/
        end
      end

      it 'calls #set_all_ssh_config' do
        vagrant.make_vfile(@hosts)
        expect(vagrant).to receive(:set_all_ssh_config)
        vagrant.configure
      end
    end

    describe '#set_all_ssh_config' do
      before do
        allow(vagrant).to receive(:set_ssh_config)
      end

      it 'calls #set_ssh_config' do
        @hosts.each do |host|
          expect(vagrant).to receive(:set_ssh_config).with(host, 'vagrant')
          expect(vagrant).to receive(:set_ssh_config).with(host, host['user'])
        end

        vagrant.set_all_ssh_config
      end

      it 'calls #copy_ssh_to_root' do
        @hosts.each do |host|
          expect(vagrant).to receive(:copy_ssh_to_root).with(host, options)
        end

        vagrant.set_all_ssh_config
      end

      it 'calls #enable_root_login' do
        @hosts.each do |host|
          expect(vagrant).to receive(:enable_root_login).with(host, options)
        end

        vagrant.set_all_ssh_config
      end

      it 'calls #hack_etc_hosts' do
        expect(vagrant).to receive(:hack_etc_hosts).with(@hosts, options)
        vagrant.set_all_ssh_config
      end
    end

    describe 'provisioning and cleanup' do
      before do
        expect(vagrant).to receive(:vagrant_cmd).with('up').once
        @hosts.each do |host|
          host_prev_name = host['user']
          expect(vagrant).to receive(:set_ssh_config).with(host, 'vagrant').once
          expect(vagrant).to receive(:copy_ssh_to_root).with(host, options).once
          expect(vagrant).to receive(:set_ssh_config).with(host, host_prev_name).once
        end
        expect(vagrant).to receive(:hack_etc_hosts).with(@hosts, options).once
      end

      it 'can provision a set of hosts' do
        options = vagrant.instance_variable_get(:@options)
        expect(vagrant).to receive(:make_vfile).with(@hosts, options).once
        expect(vagrant).not_to receive(:vagrant_cmd).with('destroy --force')
        vagrant.provision
      end

      it 'destroys an existing set of hosts before provisioning' do
        vagrant.make_vfile(@hosts)
        expect(vagrant).to receive(:vagrant_cmd).with('destroy --force').once
        vagrant.provision
      end

      it 'notifies user of failed provision' do
        vagrant.provision
        expect(vagrant).to receive(:vagrant_cmd).with('destroy --force').and_raise(RuntimeError)
        expect(options['logger']).to receive(:debug).with(/Vagrantfile/)
        expect { vagrant.provision }.to raise_error(RuntimeError)
      end

      it 'can cleanup' do
        expect(vagrant).to receive(:vagrant_cmd).with('destroy --force').once
        expect(FileUtils).to receive(:rm_rf).once

        vagrant.provision
        vagrant.cleanup
      end
    end

    describe 'provisioning and cleanup on windows' do
      before do
        expect(vagrant).to receive(:vagrant_cmd).with('up').once
        @hosts.each do |host|
          host[:platform] = 'windows'
          host_prev_name = host['user']
          expect(vagrant).not_to receive(:set_ssh_config).with(host, 'vagrant')
          expect(vagrant).not_to receive(:copy_ssh_to_root).with(host, options)
          expect(vagrant).to receive(:set_ssh_config).with(host, host_prev_name).once
        end
        expect(vagrant).to receive(:hack_etc_hosts).with(@hosts, options).once
      end

      it 'can provision a set of hosts' do
        options = vagrant.instance_variable_get(:@options)
        expect(vagrant).to receive(:make_vfile).with(@hosts, options).once
        expect(vagrant).not_to receive(:vagrant_cmd).with('destroy --force')
        vagrant.provision
      end

      it 'destroys an existing set of hosts before provisioning' do
        vagrant.make_vfile(@hosts)
        expect(vagrant).to receive(:vagrant_cmd).with('destroy --force').once
        vagrant.provision
      end

      it 'can cleanup' do
        expect(vagrant).to receive(:vagrant_cmd).with('destroy --force').once
        expect(FileUtils).to receive(:rm_rf).once

        vagrant.provision
        vagrant.cleanup
      end
    end
  end
end
