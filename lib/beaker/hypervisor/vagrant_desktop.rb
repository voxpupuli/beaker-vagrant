require 'beaker/hypervisor/vagrant'

class Beaker::VagrantDesktop < Beaker::Vagrant
  def provision(provider = 'vmware_desktop')
    super
  end

  def self.provider_vfile_section(host, options)
    v_provider = "    v.vm.provider :vmware_desktop do |v|\n"
    v_provider <<  "      v.vmx['gui'] = true\n" if host['gui'] == true
    v_provider <<  "      v.vmx['memsize'] = '#{memsize(host, options)}'\n"
    unless host['whitelist_verified'].nil?
      v_provider <<  "      v.vmx['whitelist_verified'] = '#{host['whitelist_verified']}'\n"
    end
    v_provider << "      v.vmx['functional_hgfs'] = '#{host['functional_hgfs']}'\n" unless host['functional_hgfs'].nil?
    unless host['unmount_default_hgfs'].nil?
      v_provider <<  "      v.vmx['unmount_default_hgfs'] = '#{host['unmount_default_hgfs']}'\n"
    end
    v_provider <<  "      v.vmx['utility_port'] = '#{host['utility_port']}'\n" unless host['utility_port'].nil?
    v_provider <<  "    end\n"
  end
end
