$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'beaker-vagrant/version'

Gem::Specification.new do |s|
  s.name        = 'beaker-vagrant'
  s.version     = BeakerVagrant::VERSION
  s.authors     = [
    'Vox Pupuli',
    'Rishi Javia',
    'Kevin Imber',
    'Tony Vu',
  ]
  s.email       = 'voxpupuli@groups.io'
  s.homepage    = 'https://github.com/puppetlabs/beaker-vagrant'
  s.summary     = 'Beaker DSL Extension Helpers!'
  s.description = 'For use for the Beaker acceptance testing tool'
  s.license     = 'Apache-2.0'

  s.required_ruby_version = Gem::Requirement.new('>= 2.7')

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  # Testing dependencies
  s.add_development_dependency 'fakefs', '>= 0.6', '< 3.0'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.22.0'
  s.add_development_dependency 'voxpupuli-rubocop', '~> 2.8.0'

  s.add_runtime_dependency 'beaker', '>= 4', '< 7'
end
