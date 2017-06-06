require 'stringify-hash'
require 'beaker-template/helpers'
require 'beaker-template/version'


module Beaker
  module DSL
    module Template

      # include your modules from the beaker-template folder. Example below:
      include Beaker::DSL::Template::Helpers

    end
  end
end


# Boilerplate DSL inclusion mechanism:
# First we register our module with the Beaker DSL
Beaker::DSL.register( Beaker::DSL::Template )
# Modules added into a module which has previously been included are not
# retroactively included in the including class.
#
# https://github.com/adrianomitre/retroactive_module_inclusion
Beaker::TestCase.class_eval { include Beaker::DSL }
