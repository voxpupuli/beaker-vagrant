# beaker-template

Let's construct a Beaker DSL extension library!

# Why Would We Do Such a Thing?

There are two reasons to create a Beaker library:

1. To pull functionality out of Beaker core to be maintained/improved separately (mostly QE tasks)
2. To provide additional methods to the Beaker DSL, extending Beaker functionality (biggest Beaker user use case)

These instructions are here to give people a working guide on how to create your own Beaker
libraries for the second use case. If you'd like to pull functionality out of Beaker
(the first use case), then please create a
[Beaker JIRA](https://tickets.puppetlabs.com/browse/BKR)
ticket for it, and we can discuss that there.

# Just tell me [how](#howto)

# When to create a beaker-library:
* code smells
  * repeated code across repos
  * methods duplicated from beaker
  * no/little tests, no CI for tests
* when functionality is specific to software under test
  * But is useful across multiple projects, testing libraries
  * And does not belong in Beaker-core
    * e.g.: It is not host abstraction, provisioning, nor test-running
* when functionality is specific to puppetlabs or other non-provisioning infrastructure

# When to _not_ create a beaker-library
* when changes belong in a beaker-core
  * provisioning
  * Host-abstraction (communication, information)
  * test running, assertions
https://tickets.puppetlabs.com/browse/BKR-334

<a name="howto">
# Beaker Library Creation Process Overview
</a>

This section covers the high-level process of creating a Beaker library.
If you'd like to know more about a particular step, checkout its section below.

1. Clone this repo (beaker-template)
2. Rename the library
3. Create spec tests
4. Create acceptance tests
5. Publish your library!

# Step Details

## 1. Clone this repo (beaker-template)

No hidden tricks. Just do it, people!

## 2. Rename the library

There are a number of steps required to make sure your library is namespaced & setup correctly:

### A. File structure changes

The accepted naming pattern for Beaker libraries follows from 'beaker-template',
where you change `template` to match the name of the library you're creating. Some
examples would be `beaker-hiera`, `beaker-facter`, `beaker-puppet`, etc.


Once you've chosen your library name, you'll have to change a number of files to
match it. The main project folder, and the corresponding folder under `lib` will
both have to be renamed.


The `beaker-template.rb` file under what was `lib/beaker-template` will have to
be changed to match this new name as well.

### B. Code changes

The template provides you with the default module path `Beaker::DSL::Helpers::Template`.
This path follows from the DSL pattern within Beaker, and `Beaker::DSL::Helpers`
should stay at the front of your path. `Template` should be changed to the name
of your project. This change will be needed in a number of places, and doing a
general search-and-destroy for the word `Template` should cover it.


`require` references will need to be updated as well.  Searching and replacing
all lines that include:

    require 'beaker-template

should cover all uses of this.

### C. Gemspec changes

The gemspec file has a few additional changes that will be required.


It includes both the require and module path changes.


A general audit of every line of the `beaker-template.gemspec` file should be done,
which should include renaming it to the name of the project, and changing most,
if not all, of the lines in the first block describing the library itself.

## 3. Create spec tests

Spec tests all live under the `spec` folder.  These are the default rake task, &
so can be run with a simple `bundle exec rake`, as well as being fully specified
by running `bundle exec rake test:spec:run` or using the `test:spec` task.


There are also code coverage tests built into the template, which can be run
with spec testing by running the `test:spec:coverage` rake task.


These will fail by default.  This is on purpose, as some test refactoring (and
hopefully test addition) should be done prior to wanting to release a library.
Please add more spec tests either in what started as `spec/beaker-template/helpers_spec.rb`,
or create more spec testing files under `spec/beaker-template`, and they'll be
included in spec testing automatically.

## 4. Create acceptance tests

Acceptance tests live in the `acceptance/tests` folder.  These are Beaker tests,
& are dependent on having Beaker installed. Note that this will happen with a
`bundle install` execution, but can be avoided if you're not looking to run
acceptance tests by ignoring the `acceptance_testing` gem group.


You can run the acceptance testing suite by invoking the `test:acceptance` rake
task. It should be noted that this is a shortcut for the `test:acceptance:quick`
task, which is named as such because it uses no pre-suite.  This uses a default
provided hosts file for acceptance under the `acceptance/config` directory. If
you'd like to provide your own hosts file, set the `CONFIG` environment variable.


Acceptance tests will also fail by default, for the same reason given above as
spec tests.

## 5. Publish your library!

_But wait_, you might be thinking, _what about developing the functionality?_
Sure, we expect that to happen before this step. But, we're figuring that naming
it in an explicit step would get us into a debate over TDD, or just the relative
positioning of development in general. Let's just say that you've gotten over
that part at some point in the recent past.

If you're a puppet employee who maintains a Beaker library, & you'd like to have
that library tested & published using our internal tooling & infrastructure, open a
[Beaker JIRA ticket](https://tickets.puppetlabs.com/browse/BKR) to do so, and we
can talk about setting up the Jenkins jobs to get this tested & released using those.

For someone outside the company who would like to run a similar process to what
we do internally, we just maintain two kinds of jobs for each Beaker library:

1. Test jobs that invoke the rake tasks mentioned in the testing sections. These are targeted on submitted PRs.
2. Gem publish jobs that are only manually kicked to release new versions of the Beaker library gem.

## Notes

### When to Breaking-Change

* if moving existing functionality out of beaker, first release should not be a breaking change in beaker 2.x
  * retain method and DSL naming and signature and the code move will be seamless to the user
  * add the new library to beaker’s gemspec file so it is pulled in appropriately
* always deprecate first
  * This is a manual process for now
  * use logging as appropriate to notify users of deprecations
* always conform to semver
  * [http://semver.org/]
  * TL;DR: libraries shall deprecate. Breaking changes only on major version increments
* if existing helpers are not named consistently
  * we can mitigate changes by aliasing method names and deprecating
* if existing helpers need conflicting parameter changes (method signature changes)

### Documentation and Discoverability

Beaker DSL keywords and helper methods can be difficult to find. Beaker documentation best practices and improvements can improve discoverability for existing beaker functionality and libraries.
New, published, libraries should be added to the Beaker library list in its [docs](https://github.com/puppetlabs/beaker/blob/master/docs/Beaker-Libraries.md)

Hand-crafted (non yardoc) docs should be contained, in-repo, in Markdown, so as to be fully available and PR-able.
PRs for beaker and libraries should not be accepted without yardoc changes, and beaker/docs, <library>/docs changes.

## See also:
* [beaker-windows](https://github.com/puppetlabs/beaker-windows) (a modern example)
