require 'spec_helper'

describe 'Zine' do # should be functionality
  context 'always' do # should be state
    it 'has a version number' do
      expect(Zine::VERSION).not_to be nil
    end
  end
end
