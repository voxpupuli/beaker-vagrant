require 'spec_helper'

describe Beaker::VagrantVirtualbox do
  let( :options ) { make_opts.merge({ :hosts_file => 'sample.cfg', 'logger' => double().as_null_object }) }
  let( :vagrant ) { Beaker::VagrantVirtualbox.new( @hosts, options ) }
  let(:vagrantfile_path) do
    path = vagrant.instance_variable_get( :@vagrant_path )
    File.expand_path( File.join( path, 'Vagrantfile' ))
  end

  before :each do
    @hosts = make_hosts()
  end

  it "uses the virtualbox provider for provisioning" do
    @hosts.each do |host|
      host_prev_name = host['user']
      expect( vagrant ).to receive( :set_ssh_config ).with( host, 'vagrant' ).once
      expect( vagrant ).to receive( :copy_ssh_to_root ).with( host, options ).once
      expect( vagrant ).to receive( :set_ssh_config ).with( host, host_prev_name ).once
    end
    expect( vagrant ).to receive( :hack_etc_hosts ).with( @hosts, options ).once
    expect( vagrant ).to receive( :vagrant_cmd ).with( "up --provider virtualbox" ).once
    vagrant.provision
  end

  it "can make a Vagranfile for a set of hosts" do
    path = vagrant.instance_variable_get( :@vagrant_path )

    vagrant.make_vfile( @hosts )

    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include( %Q{    v.vm.provider :virtualbox do |vb|\n      vb.customize ['modifyvm', :id, '--memory', '1024', '--cpus', '1', '--audio', 'none']\n    end})
  end

  it "can disable the vb guest plugin" do
    options.merge!({ :vbguest_plugin => 'disable' })

    vfile_section = vagrant.class.provider_vfile_section( @hosts.first, options )

    match = vfile_section.match(/vb.vbguest.auto_update = false/)

    expect( match ).to_not be nil

  end

  it "can enable ioapic(multiple cores) on hosts" do
    path = vagrant.instance_variable_get( :@vagrant_path )
    hosts = make_hosts({:ioapic => 'true'},1)

    vagrant.make_vfile( hosts )

    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include( " vb.customize ['modifyvm', :id, '--ioapic', 'on']")
  end

  it "can enable NAT DNS on hosts" do
    hosts = make_hosts({:natdns => 'on'},1)
    vagrant.make_vfile( hosts )
    vagrantfile = File.read( vagrantfile_path )

    expect( vagrantfile ).to include( " vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']")
    expect( vagrantfile ).to include( " vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']")
  end

  it "correctly provisions storage with the USB controller" do
    path = vagrant.instance_variable_get( :@vagrant_path )
    hosts = make_hosts({:volumes => { 'test_disk' => { size: '5120' }}, :volume_storage_controller => 'USB' })

    vagrant.make_vfile( hosts )
    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include(" vb.customize ['modifyvm', :id, '--usb', 'on']")
    expect( vagrantfile ).to include(" vb.customize ['storagectl', :id, '--name', 'Beaker USB Controller', '--add', 'usb', '--portcount', '8', '--controller', 'USB', '--bootable', 'off']")
    expect( vagrantfile ).to include(" vb.customize ['createhd', '--filename', 'vm1-test_disk.vdi', '--size', '5120']")
    expect( vagrantfile ).to include(" vb.customize ['storageattach', :id, '--storagectl', 'Beaker USB Controller', '--port', '0', '--device', '0', '--type', 'hdd', '--medium', 'vm1-test_disk.vdi']")
  end

  it "correctly provisions storage with the LSILogic controller" do
    path = vagrant.instance_variable_get( :@vagrant_path )
    hosts = make_hosts({:volumes => { 'test_disk' => { size: '5120' }}, :volume_storage_controller => 'LSILogic' })

    vagrant.make_vfile( hosts )
    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include(" vb.customize ['storagectl', :id, '--name', 'Beaker LSILogic Controller', '--add', 'scsi', '--portcount', '16', '--controller', 'LSILogic', '--bootable', 'off']")
    expect( vagrantfile ).to include(" vb.customize ['createhd', '--filename', 'vm1-test_disk.vdi', '--size', '5120']")
    expect( vagrantfile ).to include(" vb.customize ['storageattach', :id, '--storagectl', 'Beaker LSILogic Controller', '--port', '0', '--device', '0', '--type', 'hdd', '--medium', 'vm1-test_disk.vdi']")
  end

  it "correctly provisions storage with the default controller" do
    path = vagrant.instance_variable_get( :@vagrant_path )
    hosts = make_hosts({:volumes => { 'test_disk' => { size: '5120' }}})

    vagrant.make_vfile( hosts )
    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include(" vb.customize ['storagectl', :id, '--name', 'Beaker IntelAHCI Controller', '--add', 'sata', '--portcount', '2', '--controller', 'IntelAHCI', '--bootable', 'off']")
    expect( vagrantfile ).to include(" vb.customize ['createhd', '--filename', 'vm1-test_disk.vdi', '--size', '5120']")
    expect( vagrantfile ).to include(" vb.customize ['storageattach', :id, '--storagectl', 'Beaker IntelAHCI Controller', '--port', '0', '--device', '0', '--type', 'hdd', '--medium', 'vm1-test_disk.vdi']")
  end
end
