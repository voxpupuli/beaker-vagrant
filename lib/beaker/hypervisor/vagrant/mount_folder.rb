module Beaker
  class Vagrant::MountFolder
    def initialize(name, spec)
      @name = name
      @spec = spec
    end

    def required_keys_present?
      not from.nil? and not to.nil?
    end

    def from
      @spec[:from]
    end

    def to
      @spec[:to]
    end
  end
end
