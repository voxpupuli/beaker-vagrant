module Beaker
  class Vagrant::MountFolder
    def initialize(name, spec)
      @name = name
      @spec = spec
    end

    def required_keys_present?
      !from.nil? and !to.nil?
    end

    def from
      @spec[:from]
    end

    def to
      @spec[:to]
    end
  end
end
