require 'spec_helper'
require 'zine'
require 'zine/page'

describe 'Zine::Page' do
  describe '#slug' do
    it 'has one argument' do
      expect { Zine::Page.slug }.to raise_error(ArgumentError)
    end
    it 'downcases characters' do
      expect(Zine::Page.slug('ABC')).to eql 'abc'
    end
    it 'replaces characters outside of a-z & 0-9 with dashes' do
      expect(Zine::Page.slug('abc$d')).to eql 'abc-d'
    end
    it 'removes multiple, leading and trailing dashes' do
      expect(Zine::Page.slug('$abc$$$d$')).to eql 'abc-d'
    end
  end
end
