require 'beaker/hypervisor/vagrant'

class Beaker::VagrantLibvirt < Beaker::Vagrant
  @memory = nil
  @cpu    = nil

  class << self
    attr_reader :memory
  end

  # Return a random mac address with colons
  #
  # @return [String] a random mac address
  def randmac
    "08:00:27:" + (1..3).map{"%0.2X"%rand(256)}.join(':')
  end

  def provision(provider = 'libvirt')
    # This needs to be unique for every system with the same hostname but does
    # not affect VirtualBox
    vagrant_path_digest = Digest::SHA256.hexdigest(@vagrant_path)
    @vagrant_path = @vagrant_path + '_' + vagrant_path_digest[0..2] + vagrant_path_digest[-3..-1]
    @vagrant_file = File.expand_path(File.join(@vagrant_path, "Vagrantfile"))

    super
  end

  def self.provider_vfile_section(host, options)
    "    v.vm.provider :libvirt do |node|\n" +
      "      node.cpus = #{cpus(host, options)}\n" +
      "      node.memory = #{memsize(host, options)}\n" +
      "      node.qemu_use_session = false\n" +
      build_options_str(options) +
      "    end\n"
  end

  def self.build_options_str(options)
    other_options_str = ''
    if options['libvirt']
      other_options = []
      options['libvirt'].each do |k, v|
        other_options << "      node.#{k} = '#{v}'"
      end
      other_options_str = other_options.join("\n")
    end
    "#{other_options_str}\n"
  end

  def private_network_generator(host)
    #if 'dhcp_ip' not provided, use the default example IP.
    #:libvirt__network_address is a portion of the private network options
    # and here is the relevant documentation:
    #Used only when :type is set to dhcp. Only /24 subnet is supported.
    #Default is 172.28.128.0
    unless host['dhcp_ip'].nil? || host['dhcp_ip'].empty?
      dhcp_ip = host['dhcp_ip']
    else
      dhcp_ip = "172.28.128.0"
    end
    private_network_string = "    v.vm.network :private_network, :type => \"dhcp\", :libvirt__network_address => \"#{dhcp_ip}\"\n"
  end
  
  def shell_provisioner_generator(provisioner_config)
    #hacky fix, but the default vagrant file generator overlays the route
    #by default to not handle the ip masquerade that the vagrant-libvirt
    #will provide. To work around this, by deleting the default route whenever
    #the vagrant libvirt vm comes up, it will correct itself and then the ip
    #masquerade will work as intended.
    unless provisioner_config.nil?
      shell_provisioner_string = "    v.vm.provision 'shell', :inline => 'ip route del default', :run => 'always'\n"
    else
      shell_provisioner_string = "    v.vm.provision 'shell', :inline => 'ip route del default', :run => 'always'\n"
    end
  end
end
