# Changelog

## [1.2.0](https://github.com/voxpupuli/beaker-vagrant/tree/1.2.0) (2023-04-28)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/1.1.0...1.2.0)

**Implemented enhancements:**

- Allow beaker 4 again [\#75](https://github.com/voxpupuli/beaker-vagrant/pull/75) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Switch to voxpupuli-rubocop + Rake task from voxpupuli-rubocop [\#69](https://github.com/voxpupuli/beaker-vagrant/pull/69) ([bastelfreak](https://github.com/bastelfreak))

## [1.1.0](https://github.com/voxpupuli/beaker-vagrant/tree/1.1.0) (2023-04-28)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/1.0.0...1.1.0)

**Implemented enhancements:**

- Use Bundler to clean the environment [\#73](https://github.com/voxpupuli/beaker-vagrant/pull/73) ([ekohl](https://github.com/ekohl))
- Switch to voxpupuli-rubocop [\#72](https://github.com/voxpupuli/beaker-vagrant/pull/72) ([bastelfreak](https://github.com/bastelfreak))

## [1.0.0](https://github.com/voxpupuli/beaker-vagrant/tree/1.0.0) (2023-03-27)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.7.1...1.0.0)

**Breaking changes:**

- Drop Ruby 2.4/2.5/2.6 support [\#55](https://github.com/voxpupuli/beaker-vagrant/pull/55) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Ruby 3.2 to CI [\#66](https://github.com/voxpupuli/beaker-vagrant/pull/66) ([bastelfreak](https://github.com/bastelfreak))
- Add Ruby 3.0/3.1 to CI [\#59](https://github.com/voxpupuli/beaker-vagrant/pull/59) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Rubocop: Fix layout cops [\#65](https://github.com/voxpupuli/beaker-vagrant/pull/65) ([bastelfreak](https://github.com/bastelfreak))
- drop yard doc generation code [\#64](https://github.com/voxpupuli/beaker-vagrant/pull/64) ([bastelfreak](https://github.com/bastelfreak))
- CI: Fix release workflow [\#63](https://github.com/voxpupuli/beaker-vagrant/pull/63) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Style cops [\#62](https://github.com/voxpupuli/beaker-vagrant/pull/62) ([bastelfreak](https://github.com/bastelfreak))
- Allow fakefs 2.x [\#61](https://github.com/voxpupuli/beaker-vagrant/pull/61) ([ekohl](https://github.com/ekohl))
- Bump actions/checkout from 2 to 3 [\#60](https://github.com/voxpupuli/beaker-vagrant/pull/60) ([dependabot[bot]](https://github.com/apps/dependabot))
- dependabot: check for github actions and gems [\#58](https://github.com/voxpupuli/beaker-vagrant/pull/58) ([bastelfreak](https://github.com/bastelfreak))
- Implement RuboCop [\#57](https://github.com/voxpupuli/beaker-vagrant/pull/57) ([bastelfreak](https://github.com/bastelfreak))
- apply best-practices to GitHub workflow [\#56](https://github.com/voxpupuli/beaker-vagrant/pull/56) ([bastelfreak](https://github.com/bastelfreak))
- Remove unused rspec-its dependency [\#52](https://github.com/voxpupuli/beaker-vagrant/pull/52) ([ekohl](https://github.com/ekohl))

## [0.7.1](https://github.com/voxpupuli/beaker-vagrant/tree/0.7.1) (2021-05-26)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.7.0...0.7.1)

**Fixed bugs:**

- Remove set\_host\_default from vagrant\_libvirt [\#50](https://github.com/voxpupuli/beaker-vagrant/pull/50) ([trevor-vaughan](https://github.com/trevor-vaughan))

**Closed issues:**

- The recent change to the set\_host\_default method in vagrant\_libvirt broke multi-node testing [\#49](https://github.com/voxpupuli/beaker-vagrant/issues/49)

**Merged pull requests:**

- Release of 0.7.1 [\#51](https://github.com/voxpupuli/beaker-vagrant/pull/51) ([trevor-vaughan](https://github.com/trevor-vaughan))

## [0.7.0](https://github.com/voxpupuli/beaker-vagrant/tree/0.7.0) (2021-05-18)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.6.7...0.7.0)

**Closed issues:**

- \(BKR-1697\) Fix libvirt support [\#39](https://github.com/voxpupuli/beaker-vagrant/issues/39)

**Merged pull requests:**

- Release 0.7.0 [\#48](https://github.com/voxpupuli/beaker-vagrant/pull/48) ([ekohl](https://github.com/ekohl))
- Stop using private networks on libvirt [\#47](https://github.com/voxpupuli/beaker-vagrant/pull/47) ([ekohl](https://github.com/ekohl))
- Correctly override the Vagrant path [\#46](https://github.com/voxpupuli/beaker-vagrant/pull/46) ([ekohl](https://github.com/ekohl))
- Remove redundant path in path construction [\#45](https://github.com/voxpupuli/beaker-vagrant/pull/45) ([ekohl](https://github.com/ekohl))
- Simplify vagrant\_libvirt option building [\#44](https://github.com/voxpupuli/beaker-vagrant/pull/44) ([ekohl](https://github.com/ekohl))
- Do not set an explicit mac address [\#43](https://github.com/voxpupuli/beaker-vagrant/pull/43) ([ekohl](https://github.com/ekohl))
- Get the SSH config from vagrant [\#42](https://github.com/voxpupuli/beaker-vagrant/pull/42) ([ekohl](https://github.com/ekohl))
- Lazily create the vagrant path [\#41](https://github.com/voxpupuli/beaker-vagrant/pull/41) ([ekohl](https://github.com/ekohl))
- Deactivate FakeFS after using it [\#40](https://github.com/voxpupuli/beaker-vagrant/pull/40) ([ekohl](https://github.com/ekohl))
- Add GH Action for releases [\#38](https://github.com/voxpupuli/beaker-vagrant/pull/38) ([genebean](https://github.com/genebean))
- Various compatible cleanups [\#33](https://github.com/voxpupuli/beaker-vagrant/pull/33) ([ekohl](https://github.com/ekohl))

## [0.6.7](https://github.com/voxpupuli/beaker-vagrant/tree/0.6.7) (2021-02-26)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.6.6...0.6.7)

**Merged pull requests:**

- Move testing to GH Actions [\#36](https://github.com/voxpupuli/beaker-vagrant/pull/36) ([genebean](https://github.com/genebean))
- Fix simultaneous runs with the libvirt hypervisor [\#35](https://github.com/voxpupuli/beaker-vagrant/pull/35) ([trevor-vaughan](https://github.com/trevor-vaughan))
- Add Dependabot to keep thins up to date [\#30](https://github.com/voxpupuli/beaker-vagrant/pull/30) ([genebean](https://github.com/genebean))

## [0.6.6](https://github.com/voxpupuli/beaker-vagrant/tree/0.6.6) (2020-03-19)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.6.5...0.6.6)

**Merged pull requests:**

- \(BKR-1423\) Fix SSH settings in nodesets [\#28](https://github.com/voxpupuli/beaker-vagrant/pull/28) ([trevor-vaughan](https://github.com/trevor-vaughan))

## [0.6.5](https://github.com/voxpupuli/beaker-vagrant/tree/0.6.5) (2020-03-10)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.6.4...0.6.5)

**Merged pull requests:**

- \(BKR-1635\) Fix and document `natdns` [\#27](https://github.com/voxpupuli/beaker-vagrant/pull/27) ([op-ct](https://github.com/op-ct))

## [0.6.4](https://github.com/voxpupuli/beaker-vagrant/tree/0.6.4) (2020-01-21)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.6.3...0.6.4)

**Merged pull requests:**

- Fix WinRM error message matching [\#26](https://github.com/voxpupuli/beaker-vagrant/pull/26) ([trevor-vaughan](https://github.com/trevor-vaughan))

## [0.6.3](https://github.com/voxpupuli/beaker-vagrant/tree/0.6.3) (2019-12-17)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.6.2...0.6.3)

**Merged pull requests:**

- Work around common WinRM issue in Vagrant [\#25](https://github.com/voxpupuli/beaker-vagrant/pull/25) ([trevor-vaughan](https://github.com/trevor-vaughan))
- \(BKR-1628\) fix up CI for coming changes [\#24](https://github.com/voxpupuli/beaker-vagrant/pull/24) ([kevpl](https://github.com/kevpl))
- Never use QEMU session with libvirt [\#23](https://github.com/voxpupuli/beaker-vagrant/pull/23) ([ekohl](https://github.com/ekohl))

## [0.6.2](https://github.com/voxpupuli/beaker-vagrant/tree/0.6.2) (2019-02-11)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.6.1...0.6.2)

**Merged pull requests:**

- Use winrm communicator for Windows [\#22](https://github.com/voxpupuli/beaker-vagrant/pull/22) ([treydock](https://github.com/treydock))
- \(BKR-1553\) Set PermitUserEnvironment [\#21](https://github.com/voxpupuli/beaker-vagrant/pull/21) ([ekohl](https://github.com/ekohl))
- Call configure method of parent class. [\#20](https://github.com/voxpupuli/beaker-vagrant/pull/20) ([tdevelioglu](https://github.com/tdevelioglu))
- remove audio of SUT with virtualbox [\#18](https://github.com/voxpupuli/beaker-vagrant/pull/18) ([Dan33l](https://github.com/Dan33l))

## [0.6.1](https://github.com/voxpupuli/beaker-vagrant/tree/0.6.1) (2018-12-13)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.6.0...0.6.1)

**Merged pull requests:**

- Set RUBYOPT to an empty string for bundler [\#19](https://github.com/voxpupuli/beaker-vagrant/pull/19) ([ekohl](https://github.com/ekohl))

## [0.6.0](https://github.com/voxpupuli/beaker-vagrant/tree/0.6.0) (2018-11-13)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.5.0...0.6.0)

**Merged pull requests:**

- \(BKR-1509\) Hypervisor usage instructions for Beaker 4.0 [\#17](https://github.com/voxpupuli/beaker-vagrant/pull/17) ([Dakta](https://github.com/Dakta))
- BKR-1508 [\#16](https://github.com/voxpupuli/beaker-vagrant/pull/16) ([ardeshireshghi](https://github.com/ardeshireshghi))
- \(MAINT\) Upgrade acceptance tests and docs [\#15](https://github.com/voxpupuli/beaker-vagrant/pull/15) ([Dakta](https://github.com/Dakta))
- Fix `BEAKER_provision=no` workflow [\#13](https://github.com/voxpupuli/beaker-vagrant/pull/13) ([joshuaspence](https://github.com/joshuaspence))

## [0.5.0](https://github.com/voxpupuli/beaker-vagrant/tree/0.5.0) (2018-05-03)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.4.0...0.5.0)

**Merged pull requests:**

- \(maint\) add support for extra vmware configuration [\#14](https://github.com/voxpupuli/beaker-vagrant/pull/14) ([lmayorga1980](https://github.com/lmayorga1980))
- Bugfix: Issue with user given invalid keys for synced folders [\#9](https://github.com/voxpupuli/beaker-vagrant/pull/9) ([cardil](https://github.com/cardil))

## [0.4.0](https://github.com/voxpupuli/beaker-vagrant/tree/0.4.0) (2018-02-22)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.3.0...0.4.0)

**Merged pull requests:**

- \(BKR-1237\)set vm.base\_mac for freebsd in Vagrantfile [\#6](https://github.com/voxpupuli/beaker-vagrant/pull/6) ([bastelfreak](https://github.com/bastelfreak))

## [0.3.0](https://github.com/voxpupuli/beaker-vagrant/tree/0.3.0) (2018-02-16)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.2.1...0.3.0)

**Merged pull requests:**

- Add support for alternate volume storage controllers [\#12](https://github.com/voxpupuli/beaker-vagrant/pull/12) ([beezly](https://github.com/beezly))

## [0.2.1](https://github.com/voxpupuli/beaker-vagrant/tree/0.2.1) (2018-02-12)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.2.0...0.2.1)

**Merged pull requests:**

- Improve documentation on volumes support [\#11](https://github.com/voxpupuli/beaker-vagrant/pull/11) ([beezly](https://github.com/beezly))
- add support for ioapic for virtualbox [\#10](https://github.com/voxpupuli/beaker-vagrant/pull/10) ([lmayorga1980](https://github.com/lmayorga1980))

## [0.2.0](https://github.com/voxpupuli/beaker-vagrant/tree/0.2.0) (2018-01-09)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.1.1...0.2.0)

**Merged pull requests:**

- \(BKR-1264\) Ensure vm.hostname is legal [\#8](https://github.com/voxpupuli/beaker-vagrant/pull/8) ([jcoconnor](https://github.com/jcoconnor))

## [0.1.1](https://github.com/voxpupuli/beaker-vagrant/tree/0.1.1) (2017-11-20)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/0.1.0...0.1.1)

**Merged pull requests:**

- add support for download\_insecure config [\#5](https://github.com/voxpupuli/beaker-vagrant/pull/5) ([lmayorga1980](https://github.com/lmayorga1980))

## [0.1.0](https://github.com/voxpupuli/beaker-vagrant/tree/0.1.0) (2017-07-14)

[Full Changelog](https://github.com/voxpupuli/beaker-vagrant/compare/d9545ba78c5d9ef827503c047fb7efd482734dbf...0.1.0)

**Merged pull requests:**

- \(MAINT\) Create constant for gem version [\#2](https://github.com/voxpupuli/beaker-vagrant/pull/2) ([rishijavia](https://github.com/rishijavia))
- \(MAINT\) Update README to correct hypervisor name [\#1](https://github.com/voxpupuli/beaker-vagrant/pull/1) ([rishijavia](https://github.com/rishijavia))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
