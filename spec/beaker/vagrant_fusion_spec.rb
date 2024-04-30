require 'spec_helper'

describe Beaker::VagrantFusion do
  let(:options) { make_opts.merge({ :hosts_file => 'sample.cfg', 'logger' => double.as_null_object }) }
  let(:vagrant) { described_class.new(hosts, options) }
  let(:hosts) { make_hosts }

  it 'uses the vmware_fusion provider for provisioning' do
    hosts.each do |host|
      host_prev_name = host['user']
      expect(vagrant).to receive(:set_ssh_config).with(host, 'vagrant').once
      expect(vagrant).to receive(:copy_ssh_to_root).with(host, options).once
      expect(vagrant).to receive(:set_ssh_config).with(host, host_prev_name).once
    end
    expect(vagrant).to receive(:hack_etc_hosts).with(hosts, options).once
    expect(vagrant).to receive(:vagrant_cmd).with('up --provider vmware_fusion').once
    vagrant.provision
  end

  context 'Correct vagrant configuration' do
    subject do
      FakeFS do
        vagrant.make_vfile(hosts, options)
        File.read(vagrant.instance_variable_get(:@vagrant_file))
      end
    end

    it 'has a provider section' do
      expect(subject).to include(%(    v.vm.provider :vmware_fusion do |v|\n      v.vmx['memsize'] = '1024'\n    end))
    end
  end
end
