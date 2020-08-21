require 'beaker/hypervisor/vagrant'

class Beaker::VagrantLibvirt < Beaker::Vagrant
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
end
