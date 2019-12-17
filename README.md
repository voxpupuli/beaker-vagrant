# beaker-vagrant

Beaker library to use vagrant hypervisor

# How to use this wizardry

This is a gem that allows you to use hosts with [vagrant](docs/vagrant.md) hypervisor with [beaker](https://github.com/puppetlabs/beaker). 

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

# Contributing

Please refer to puppetlabs/beaker's [contributing](https://github.com/puppetlabs/beaker/blob/master/CONTRIBUTING.md) guide.

# Release

To release new versions, we use a
[Jenkins job](https://jenkins-sre.delivery.puppetlabs.net/view/all/job/qe_beaker-vagrant_init-multijob_master/)
(access to internal infrastructure will be required to view job).

To release a new version (from the master branch), you'll need to just provide
a new beaker-pe version number to the job, and you're off to the races.
