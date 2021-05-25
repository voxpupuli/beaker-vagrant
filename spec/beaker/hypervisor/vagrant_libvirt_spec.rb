require 'spec_helper'

describe Beaker::VagrantLibvirt do
  let( :options ) { make_opts.merge({ :hosts_file => 'sample.cfg',
                                      'logger' => double().as_null_object,
                                      'libvirt' => { 'uri' => 'qemu+ssh://root@host/system'},
                                      'vagrant_cpus' => 2,
                                    }) }
  let( :vagrant ) { described_class.new( hosts, options ) }
  let( :hosts ) do
    make_hosts().each do |host|
      host.delete('ip')
    end
  end

  it "uses the vagrant_libvirt provider for provisioning" do
    hosts.each do |host|
      host_prev_name = host['user']
      expect( vagrant ).to receive( :set_ssh_config ).with( host, 'vagrant' ).once
      expect( vagrant ).to receive( :copy_ssh_to_root ).with( host, options ).once
      expect( vagrant ).to receive( :set_ssh_config ).with( host, host_prev_name ).once
    end
    expect( vagrant ).to receive( :hack_etc_hosts ).with( hosts, options ).once
    expect( vagrant ).to receive( :vagrant_cmd ).with( "up --provider libvirt" ).once
    FakeFS do
      vagrant.provision
    end
  end

  context 'Correct vagrant configuration' do
    subject do
      FakeFS do
        vagrant.make_vfile( hosts, options )
        File.read(vagrant.instance_variable_get(:@vagrant_file))
      end
    end

    it 'has a provider section' do
      is_expected.to include( %Q{    v.vm.provider :libvirt do |node|})
    end

    it "has no private network" do
      is_expected.to include('v.vm.network :private_network')
    end

    it "can specify the memory as an integer" do
      is_expected.to include('node.memory = 1024')
    end

    it "can specify the number of cpus" do
      is_expected.to include("node.cpus = 2")
    end

    it "can specify any libvirt option" do
      is_expected.to include("node.uri = 'qemu+ssh://root@host/system'")
    end
  end
end
