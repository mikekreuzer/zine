require 'spec_helper'
require 'zine'
require 'zine/CLI'

describe 'Zine::CLI' do
  let(:cli) { Zine::CLI.new }
  let(:minimal_yaml) do
    '---
    directories:
        assets: assets
        blog: blog
        build: build
        posts: posts
        source: source
        styles: styles
        templates: templates
    templates:
    options:'
  end
  subject { cli }

  describe '#build' do
    it 'has no arguments' do
      expect { subject.build('My site') }.to raise_error(ArgumentError)
    end

    context 'with no YAML options file' do
      it 'raises an error' do
        expect { subject.build }.to raise_error(Errno::ENOENT)
      end
    end

    context 'with a (mocked) YAML options file' do
      # it 'outputs a success message' do
      #  allow(File).to receive(:open) do
      #    minimal_yaml
      #  end
      #  expect { subject.build }.to output(/Site built/).to_stdout
      # end

      # will fail until decide on a background job style (for the preview here)

      # context 'with an error' do
      #  it 'outputs an error message' do
      #    allow(File).to receive(:open) do
      #      minimal_yaml
      #    end
      #    # up to here...
      #    allow(:build_site).to receive('').and_return(false)
      #    expect { subject.build }.to output(/Errors building the site/).to_stdout
      #  end
      # end
    end
  end

  describe '#version' do
    it 'has no arguments' do
      expect { subject.version('Anything') }.to raise_error(ArgumentError)
    end
    it 'outputs the correct version' do
      expect { subject.version }.to output("#{Zine::VERSION}\n").to_stdout
    end
  end
end
