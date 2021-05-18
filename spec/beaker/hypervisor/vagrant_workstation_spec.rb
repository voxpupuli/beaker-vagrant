require 'spec_helper'

describe Beaker::VagrantWorkstation do
  let( :options ) { make_opts.merge({ :hosts_file => 'sample.cfg', 'logger' => double().as_null_object }) }
  let( :vagrant ) { Beaker::VagrantWorkstation.new( @hosts, options ) }

  before :each do
    @hosts = make_hosts()
  end

  it "uses the vmware_workstation provider for provisioning" do
    @hosts.each do |host|
      host_prev_name = host['user']
      expect( vagrant ).to receive( :set_ssh_config ).with( host, 'vagrant' ).once
      expect( vagrant ).to receive( :copy_ssh_to_root ).with( host, options ).once
      expect( vagrant ).to receive( :set_ssh_config ).with( host, host_prev_name ).once
    end
    expect( vagrant ).to receive( :hack_etc_hosts ).with( @hosts, options ).once
    expect( vagrant ).to receive( :vagrant_cmd ).with( "up --provider vmware_workstation" ).once
    vagrant.provision
  end

  it "can make a Vagranfile for a set of hosts" do
    path = vagrant.instance_variable_get( :@vagrant_path )

    vagrant.make_vfile( @hosts )

    vagrantfile = File.read( File.expand_path( File.join( path, "Vagrantfile")))
    expect( vagrantfile ).to include( %Q{    v.vm.provider :vmware_workstation do |v|\n      v.vmx['memsize'] = '1024'\n    end})
  end

  it "can enable whitelist_verified on hosts" do 
    path = vagrant.instance_variable_get( :@vagrant_path )
    hosts = make_hosts({:whitelist_verified => true},1)

    vagrant.make_vfile( hosts )

    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include( %Q{ v.vmx['whitelist_verified'] = 'true'})
  end

  it "can enable functional_hgfs on hosts" do 
    path = vagrant.instance_variable_get( :@vagrant_path )
    hosts = make_hosts({:functional_hgfs => true},1)

    vagrant.make_vfile( hosts )

    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include( %Q{ v.vmx['functional_hgfs'] = 'true'})
  end

  it "can enable unmount_default_hgfs on hosts" do 
    path = vagrant.instance_variable_get( :@vagrant_path )
    hosts = make_hosts({:unmount_default_hgfs => true},1)

    vagrant.make_vfile( hosts )

    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include( %Q{ v.vmx['unmount_default_hgfs'] = 'true'})
  end

  it "can enable gui on hosts" do 
    path = vagrant.instance_variable_get( :@vagrant_path )
    hosts = make_hosts({:gui => true},1)

    vagrant.make_vfile( hosts )

    vagrantfile = File.read( File.expand_path( File.join( path, 'Vagrantfile' )))
    expect( vagrantfile ).to include( %Q{ v.vmx['gui'] = true})
  end
end
