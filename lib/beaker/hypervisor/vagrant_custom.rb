require 'beaker/hypervisor/vagrant'

class Beaker::VagrantCustom < Beaker::Vagrant
  def provision(provider = nil)
    super
  end

  def make_vfile(_hosts, _options = {})
    FileUtils.mkdir_p(@vagrant_path)
    FileUtils.cp(@options[:vagrantfile_path], @vagrant_file)
  end
end
