# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'beaker-vagrant/version'

Gem::Specification.new do |s|
  s.name        = "beaker-vagrant"
  s.version     = BeakerVagrant::VERSION
  s.authors     = ["Rishi Javia, Kevin Imber, Tony Vu"]
  s.email       = ["rishi.javia@puppet.com, kevin.imber@puppet.com, tony.vu@puppet.com"]
  s.homepage    = "https://github.com/puppetlabs/beaker-vagrant"
  s.summary     = %q{Beaker DSL Extension Helpers!}
  s.description = %q{For use for the Beaker acceptance testing tool}
  s.license     = 'Apache2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Testing dependencies
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its'
  # pin fakefs for Ruby < 2.3
  if RUBY_VERSION < "2.3"
    s.add_development_dependency 'fakefs', '~> 0.6', '< 0.14'
  else
    s.add_development_dependency 'fakefs', '~> 0.6'
  end
  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'pry', '~> 0.10'

  # Documentation dependencies
  s.add_development_dependency 'yard'
  s.add_development_dependency 'thin'
end

