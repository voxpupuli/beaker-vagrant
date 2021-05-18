require 'spec_helper'

describe Beaker::VagrantWorkstation do
  let( :options ) { make_opts.merge({ :hosts_file => 'sample.cfg', 'logger' => double().as_null_object }) }
  let( :vagrant ) { described_class.new( hosts, options ) }
  let( :hosts ) { make_hosts() }

  it "uses the vmware_workstation provider for provisioning" do
    hosts.each do |host|
      host_prev_name = host['user']
      expect( vagrant ).to receive( :set_ssh_config ).with( host, 'vagrant' ).once
      expect( vagrant ).to receive( :copy_ssh_to_root ).with( host, options ).once
      expect( vagrant ).to receive( :set_ssh_config ).with( host, host_prev_name ).once
    end
    expect( vagrant ).to receive( :hack_etc_hosts ).with( hosts, options ).once
    expect( vagrant ).to receive( :vagrant_cmd ).with( "up --provider vmware_workstation" ).once
    FakeFS do
      vagrant.provision
    end
  end

  context 'can make a Vagrantfile' do
    subject do
      FakeFS do
        vagrant.make_vfile(hosts)
        File.read(vagrant.instance_variable_get(:@vagrant_file))
      end
    end

    it "for a set of hosts" do
      is_expected.to include( %Q{    v.vm.provider :vmware_workstation do |v|\n      v.vmx['memsize'] = '1024'\n    end})
    end

    context 'with whitelist_verified' do
      let(:hosts) { make_hosts({:whitelist_verified => true}, 1) }

      it { is_expected.to include( %Q{ v.vmx['whitelist_verified'] = 'true'}) }
    end

    context 'with functional_hgfs' do
      let(:hosts) { make_hosts({:functional_hgfs => true}, 1) }

      it { is_expected.to include( %Q{ v.vmx['functional_hgfs'] = 'true'}) }
    end

    context 'with unmount_default_hgfs' do
      let(:hosts) { make_hosts({:unmount_default_hgfs => true}, 1) }

      it { is_expected.to include( %Q{ v.vmx['unmount_default_hgfs'] = 'true'}) }
    end

    context "with gui" do
      let(:hosts) { make_hosts({:gui => true},1) }

      it { is_expected.to include( %Q{ v.vmx['gui'] = true}) }
    end
  end
end
