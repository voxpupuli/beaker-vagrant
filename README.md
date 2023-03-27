# beaker-vagrant

[![License](https://img.shields.io/github/license/voxpupuli/beaker-vagrant.svg)](https://github.com/voxpupuli/beaker-vagrant/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/beaker-vagrant/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/beaker-vagrant/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/voxpupuli/beaker-vagrant/branch/master/graph/badge.svg?token=Mypkl78hvK)](https://codecov.io/gh/voxpupuli/beaker-vagrant)
[![Release](https://github.com/voxpupuli/beaker-vagrant/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/beaker-vagrant/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/beaker-vagrant.svg)](https://rubygems.org/gems/beaker-vagrant)
[![RubyGem Downloads](https://img.shields.io/gem/dt/beaker-vagrant.svg)](https://rubygems.org/gems/beaker-vagrant)
[![Donated by Puppet Inc](https://img.shields.io/badge/donated%20by-Puppet%20Inc-fb7047.svg)](#transfer-notice)

Beaker library to use vagrant hypervisor

# How to use this wizardry

This is a gem that allows you to use hosts with [vagrant](docs/vagrant.md) hypervisor with [beaker](https://github.com/voxpupuli/beaker).

## With Beaker 3.x

This library is included as a dependency of Beaker 3.x versions, so there's nothing to do.

## With Beaker 4.x

As of Beaker 4.0, all hypervisor and DSL extension libraries have been removed and are no longer dependencies. In order to use a specific hypervisor or DSL extension library in your project, you will need to include them alongside Beaker in your Gemfile or project.gemspec. E.g.

~~~ruby
# Gemfile
gem 'beaker', '~>4.0'
gem 'beaker-vagrant'
# project.gemspec
s.add_runtime_dependency 'beaker', '~>4.0'
s.add_runtime_dependency 'beaker-vagrant'
~~~

# Spec tests

Spec test live under the `spec` folder. There are the default rake task and therefore can run with a simple command:
```bash
bundle exec rake test:spec
```

# Acceptance tests

We run beaker's base acceptance tests with this library to see if the hypervisor is working with beaker. There is a simple rake task to invoke acceptance test for the library:
```bash
bundle exec rake test:acceptance
```

## Transfer Notice

This plugin was originally authored by [Puppet Inc](http://puppet.com).
The maintainer preferred that Puppet Community take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here.

Previously: https://github.com/puppetlabs/beaker

## License

This gem is licensed under the Apache-2 license.

## Release information

To make a new release, please do:
* update the version in `lib/beaker-vagrant/version.rb`
* Install gems with `bundle install --with release --path .vendor`
* generate the changelog with `bundle exec rake changelog`
* Check if the new version matches the closed issues/PRs in the changelog
* Create a PR with it
* After it got merged, push a tag. GitHub actions will do the actual release to rubygems and GitHub Packages
