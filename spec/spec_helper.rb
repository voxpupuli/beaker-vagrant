require 'simplecov'
require 'rspec/its'
require 'beaker'

Dir.glob('/Users/rishi.javia/Documents/beaker-vagrant/lib/beaker/hypervisor/*.rb') do |file|
  require_relative file
end

# setup & require beaker's spec_helper.rb
beaker_gem_spec = Gem::Specification.find_by_name('beaker')
beaker_gem_dir = beaker_gem_spec.gem_dir
beaker_spec_path = File.join(beaker_gem_dir, 'spec')
$LOAD_PATH << beaker_spec_path
require File.join(beaker_spec_path, 'spec_helper.rb')

RSpec.configure do |config|
  config.include TestFileHelpers
  config.include HostHelpers
end
