require 'beaker/hypervisor/vagrant'

class Beaker::VagrantDesktop < Beaker::Vagrant
  def provision(provider = 'vmware_workstation')
    super
  end

  def self.provider_vfile_section(host, options)
    "    v.vm.provider :vmware_desktop do |v|\n" +
      "      v.vmx['memsize'] = '#{memsize(host,options)}'\n" +
      "    end\n"
  end
end
