require 'spec_helper'
require 'zine/style'

describe 'Zine::Style' do
  let(:src_dir) { File.join('..', '..', 'lib', 'zine', 'skeleton', 'source') }
  let(:dir) do
    {
      'styles' => File.expand_path(File.join(src_dir, 'styles'), __FILE__),
      'source' => File.expand_path(src_dir, __FILE__)
    }
  end
  describe '#new' do
    it 'has one argument' do
      expect { Zine::Style.new }.to raise_error(ArgumentError)
    end
    it 'creates a Style object' do
      style = Zine::Style.new dir
      expect(style).to be_instance_of(Zine::Style)
    end
  end

  describe '#process' do
    it 'has one argument' do
      style = Zine::Style.new dir
      expect { style.process }.to raise_error(ArgumentError)
    end

    it 'generates the expected CSS' do
      style = Zine::Style.new dir
      output = style.process MockFile
      path_string = File.join dir['source'], 'screen.css'
      expected_content = File.read path_string
      expect(output).to eql(path: path_string, content: expected_content)
    end
  end
end
