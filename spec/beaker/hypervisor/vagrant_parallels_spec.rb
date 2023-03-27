require 'spec_helper'

describe Beaker::VagrantParallels do
  let(:options) { make_opts.merge({ :hosts_file => 'sample.cfg', 'logger' => double.as_null_object }) }
  let(:vagrant) { Beaker::VagrantParallels.new(hosts, options) }
  let(:hosts) { make_hosts }

  it 'uses the parallels provider for provisioning' do
    hosts.each do |host|
      host_prev_name = host['user']
      expect(vagrant).to receive(:set_ssh_config).with(host, 'vagrant').once
      expect(vagrant).to receive(:copy_ssh_to_root).with(host, options).once
      expect(vagrant).to receive(:set_ssh_config).with(host, host_prev_name).once
    end
    expect(vagrant).to receive(:hack_etc_hosts).with(hosts, options).once
    expect(vagrant).to receive(:vagrant_cmd).with('up --provider parallels').once
    vagrant.provision
  end

  context 'Correct vagrant configuration' do
    subject do
      FakeFS do
        vagrant.make_vfile(hosts, options)
        File.read(vagrant.instance_variable_get(:@vagrant_file))
      end
    end

    it 'can make a Vagrantfile for a set of hosts' do
      is_expected.to include(%(    v.vm.provider :parallels do |prl|\n      prl.optimize_power_consumption = false\n      prl.memory = '1024'\n    end))
    end
  end

  context 'disabled guest tools' do
    let(:options) { super().merge({ prl_update_guest_tools: 'disable' }) }
    subject { vagrant.class.provider_vfile_section(hosts.first, options) }

    it 'can disable the auto-update functionality of the Parallels Guest Tools' do
      is_expected.to match(/prl.update_guest_tools = false/)
    end
  end
end
