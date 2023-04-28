require 'open3'

module Beaker
  class Vagrant < Beaker::Hypervisor
    require 'beaker/hypervisor/vagrant/mount_folder'
    require 'beaker/hypervisor/vagrant_virtualbox'

    def rand_chunk
      rand(2..254).to_s # don't want a 0, 1, or a 255
    end

    def randip(hypervisor = nil)
      case hypervisor
      when /libvirt/
        "10.254.#{rand_chunk}.#{rand_chunk}"
      else
        "10.255.#{rand_chunk}.#{rand_chunk}"
      end
    end

    def private_network_generator(host)
      private_network_string = "    v.vm.network :private_network, ip: \"#{host['ip'].to_s}\", :netmask => \"#{host['netmask'] ||= '255.255.0.0'}\""
      private_network_string << if host['network_mac']
                                  ", :mac => \"#{host['network_mac']}\"\n"
                                else
                                  "\n"
                                end
    end

    def connection_preference(host)
      [:hostname]
    end

    def shell_provisioner_generator(provisioner_config)
      if provisioner_config['path'].nil? || provisioner_config['path'].empty?
        raise 'No path defined for shell_provisioner or path empty'
      end

      if provisioner_config['args'].nil?
        "    v.vm.provision 'shell', :path => '#{provisioner_config['path']}'\n"
      else
        "    v.vm.provision 'shell', :path => '#{provisioner_config['path']}', :args => '#{provisioner_config['args']}' \n"
      end
    end

    def make_vfile(hosts, options = {})
      # HACK: HACK HACK - add checks here to ensure that we have box + box_url
      # generate the VagrantFile
      v_file = "Vagrant.configure(\"2\") do |c|\n"
      v_file << "  c.ssh.forward_agent = true\n" if options[:forward_ssh_agent] == true
      v_file << "  c.ssh.insert_key = false\n"

      hosts.each do |host|
        host.name.tr!('_', '-') # Rewrite Hostname with hyphens instead of underscores to get legal hostname
        set_host_default_ip(host)
        v_file << "  c.vm.define '#{host.name}' do |v|\n"
        v_file << "    v.vm.hostname = '#{host.name}'\n"
        v_file << "    v.vm.box = '#{host['box']}'\n"
        v_file << "    v.vm.box_url = '#{host['box_url']}'\n" unless host['box_url'].nil?
        v_file << "    v.vm.box_version = '#{host['box_version']}'\n" unless host['box_version'].nil?
        unless host['box_download_insecure'].nil?
          v_file << "    v.vm.box_download_insecure = '#{host['box_download_insecure']}'\n"
        end
        v_file << "    v.vm.box_check_update = '#{host['box_check_update'] ||= 'true'}'\n"
        v_file << "    v.vm.synced_folder '.', '/vagrant', disabled: true\n" if host['synced_folder'] == 'disabled'
        v_file << shell_provisioner_generator(host['shell_provisioner']) if host['shell_provisioner']
        v_file << private_network_generator(host) if host['ip']

        unless host['mount_folders'].nil?
          host['mount_folders'].each do |name, folder|
            mount_folder = Vagrant::MountFolder.new(name, folder)
            if mount_folder.required_keys_present?
              v_file << "    v.vm.synced_folder '#{mount_folder.from}', '#{mount_folder.to}', create: true\n"
            else
              @logger.warn "Using 'mount_folders' requires options 'from' and 'to' for vagrant node, given #{folder.inspect}"
            end
          end
        end

        unless host['forwarded_ports'].nil?
          host['forwarded_ports'].each do |_name, port|
            fwd = '    v.vm.network :forwarded_port,'
            fwd << " protocol: '#{port[:protocol]}'," unless port[:protocol].nil?
            fwd << " guest_ip: '#{port[:to_ip]}'," unless port[:to_ip].nil?
            fwd << " guest: #{port[:to]},"
            fwd << " host_ip: '#{port[:from_ip]}'," unless port[:from_ip].nil?
            fwd << " host: #{port[:from]}"
            fwd << "\n"

            v_file << fwd
          end
        end

        if /windows/i.match(host['platform'])
          # due to a regression bug in versions of vagrant 1.6.2, 1.6.3, 1.6.4, >= 1.7.3 ssh fails to forward
          # automatically (note <=1.6.1, 1.6.5, 1.7.0 - 1.7.2 are uneffected)
          # Explicitly setting SSH port forwarding due to this bug
          v_file << "    v.vm.network :forwarded_port, guest: 22, host: 2222, id: 'ssh', auto_correct: true\n"
          v_file << "    v.vm.network :forwarded_port, guest: 3389, host: 3389, id: 'rdp', auto_correct: true\n"
          v_file << "    v.vm.network :forwarded_port, guest: 5985, host: 5985, id: 'winrm', auto_correct: true\n"
          v_file << "    v.vm.guest = :windows\n"
          v_file << "    v.vm.communicator = 'winrm'\n"
        end

        if /osx/i.match(host['platform'])
          v_file << "    v.vm.network 'private_network', ip: '10.0.1.10'\n"
          v_file << "    v.vm.synced_folder '.', '/vagrant', :nfs => true\n"
        end

        if /freebsd/i.match(host['platform'])
          v_file << "    v.ssh.shell = 'sh'\n"
          v_file << "    v.vm.guest = :freebsd\n"

          # FreeBSD NFS has a character restriction of 88 characters
          # So you can enable it but if your module has a long name it probably won't work...
          # So to keep things simple let's rsync by default!
          #
          # Further reading if interested:
          # http://www.secnetix.de/olli/FreeBSD/mnamelen.hawk
          # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=167105
          #
          v_file << if host['vagrant_freebsd_nfs'].nil?
                      "    v.vm.synced_folder '.', '/vagrant', type: 'rsync'\n"
                    else
                      "    v.vm.synced_folder '.', '/vagrant', :nfs => true\n"
                    end
        end

        v_file << self.class.provider_vfile_section(host, options)

        v_file << "  end\n"
        @logger.debug "created Vagrantfile for VagrantHost #{host.name}"
      end
      v_file << "end\n"

      # In case this is called directly
      FileUtils.mkdir_p(@vagrant_path)
      File.write(@vagrant_file, v_file)
    end

    def self.provider_vfile_section(host, options)
      # Backwards compatibility; default to virtualbox
      Beaker::VagrantVirtualbox.provider_vfile_section(host, options)
    end

    def set_all_ssh_config
      @logger.debug 'configure vagrant boxes (set ssh-config, switch to root user, hack etc/hosts)'
      @hosts.each do |host|
        if host[:platform] =~ /windows/
          @logger.debug "skip ssh hacks on windows box #{host[:name]}"
          set_ssh_config host, host['user']
          next
        end

        default_user = host['user']

        set_ssh_config host, 'vagrant'

        # copy vagrant's keys to roots home dir, to allow for login as root
        copy_ssh_to_root host, @options
        # ensure that root login is enabled for this host
        enable_root_login host, @options
        # shut down connection, will reconnect on next exec
        host.close

        set_ssh_config host, default_user

        # allow the user to set the env
        begin
          host.ssh_permit_user_environment
          host.close
        rescue ArgumentError => e
          @logger.debug("Failed to set SshPermitUserEnvironment. #{e}")
        end
      end

      hack_etc_hosts @hosts, @options
    end

    def set_ssh_config(host, user)
      return unless Dir.exist?(@vagrant_path)

      ssh_config = Dir.chdir(@vagrant_path) do
        stdout, _, status = with_unbundled_env { Open3.capture3(@vagrant_env, 'vagrant', 'ssh-config', host.name) }
        raise "Failed to 'vagrant ssh-config' for #{host.name}" unless status.success?

        Tempfile.create do |f|
          f.write(stdout)
          f.flush

          Net::SSH::Config.for(host.name, [f.path])
        end
      end

      ssh_config[:user] = user
      ssh_config[:keys_only] = false if @options[:forward_ssh_agent] == true

      host['ssh'] = host['ssh'].merge(ssh_config)
      host['user'] = user
    end

    def initialize(vagrant_hosts, options)
      require 'tempfile'
      @options = options
      @logger = options[:logger]
      @hosts = vagrant_hosts
      @vagrant_path = File.expand_path(File.join('.vagrant', 'beaker_vagrant_files',
                                                 'beaker_' + File.basename(options[:hosts_file])))
      @vagrant_file = File.expand_path(File.join(@vagrant_path, 'Vagrantfile'))
      @vagrant_env = {}
    end

    def configure(opts = {})
      unless @options[:provision]
        unless File.file?(@vagrant_file)
          raise "Beaker is configured with provision = false but no vagrant file was found at #{@vagrant_file}. You need to enable provision"
        end

        set_all_ssh_config
      end
      super
    end

    def provision(provider = nil)
      FileUtils.mkdir_p(@vagrant_path)

      # setting up new vagrant hosts
      # make sure that any old boxes are dead dead dead
      begin
        vagrant_cmd('destroy --force') if File.file?(@vagrant_file)
      rescue RuntimeError => e
        # LATER: use <<~MESSAGE once we're on Ruby 2.3
        @logger.debug(%(
          Beaker failed to destroy the existing VM's. If you think this is
          an error or you upgraded from an older version of beaker try
          verifying the VM exists and deleting the existing Vagrantfile if
          you believe it is safe to do so. WARNING: If a VM still exists
          please run 'vagrant destroy'.
          cd #{@vagrant_path}
          vagrant status
          vagrant destroy # only need to run this is a VM is not created
          rm #{@vagrant_file} # only do this if all VM's are actually destroyed
        ).each_line.map(&:strip).join("\n"))
        raise e
      end

      make_vfile @hosts, @options

      vagrant_cmd("up#{" --provider #{provider}" if provider}")

      set_all_ssh_config
    end

    def cleanup
      @logger.debug 'removing temporary ssh-config files per-vagrant box'
      @logger.notify 'Destroying vagrant boxes'
      vagrant_cmd('destroy --force')
      FileUtils.rm_rf(@vagrant_path)
    end

    def vagrant_cmd(args)
      Dir.chdir(@vagrant_path) do
        retries ||= 0
        with_unbundled_env do
          Open3.popen3(@vagrant_env, "vagrant #{args}") do |stdin, stdout, stderr, wait_thr|
            while line = stdout.gets
              @logger.info(line)
            end

            raise "Failed to exec 'vagrant #{args}'. Error was #{stderr.read}" unless wait_thr.value.success?
          end
        end
      rescue StandardError => e
        if e.to_s =~ /WinRM/m
          sleep(10)

          retry if (retries += 1) < 6
        end

        raise e
      end
    end

    def self.cpus(host, options)
      if host['vagrant_cpus']
        host['vagrant_cpus']
      elsif options['vagrant_cpus']
        options['vagrant_cpus']
      else
        '1'
      end
    end

    def self.memsize(host, options)
      if host['vagrant_memsize']
        host['vagrant_memsize']
      elsif options['vagrant_memsize']
        options['vagrant_memsize']
      elsif host['platform'] =~ /windows/
        '2048'
      else
        '1024'
      end
    end

    private

    def set_host_default_ip(host)
      host['ip'] ||= randip(host.host_hash[:hypervisor]) # use the existing ip, otherwise default to a random ip
    end

    def with_unbundled_env(&block)
      if defined?(::Bundler)
        Bundler.with_unbundled_env(&block)
      else
        yield
      end
    end
  end
end
