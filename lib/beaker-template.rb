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
# Then we have to re-include our amended DSL in the TestCase,
# because in general, the DSL is included in TestCase far
# before test files are executed, so our amendments wouldn't
# come through otherwise
include Beaker::DSL
