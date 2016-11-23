require 'spec_helper'

class ClassMixedWithDSLHelpers
  include BeakerTestHelpers
  include Beaker::DSL::Template::Helpers

  def logger
    RSpec::Mocks::Double.new('logger').as_null_object
  end

end

describe ClassMixedWithDSLHelpers do

  describe 'release conditions' do

    it 'has updated the version number from the original template' do
      expect( Beaker::DSL::Template::Version::STRING ).to_not be === '0.0.1rc0'
    end

    it 'has a MAINTAINERS doc' do
      expect( File.exist?( 'MAINTAINERS' ) ).to be_truthy
    end

  end
end
