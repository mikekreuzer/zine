require 'spec_helper'
require 'zine'
require 'zine/CLI'
require 'zine/style'

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

  describe '#init_site' do
    it 'reads a YAML options file and creates a Zine::Site object' do
      allow(File)
        .to receive(:open)
        .with('zine.yaml')
        .and_return(
          StringIO.new(minimal_yaml)
        )
      subject.init_site
      expect(subject.the_site).to be_instance_of(Zine::Site)
    end
  end

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

  describe '#style' do
    it 'has no arguments' do
      expect { subject.style('Anything') }.to raise_error(ArgumentError)
    end
    it 'outputs a message when complete' do
      # tested in CLI#init_site
      allow(File)
        .to receive(:open)
        .with('zine.yaml')
        .and_return(
          StringIO.new(minimal_yaml)
        )
      # SCSS reading & CSS generation tested in style_spec
      allow(File)
        .to receive(:open)
        .with('source/styles/screen.scss', 'r')
        .and_return(
          StringIO.new('')
        )
      allow(File)
        .to receive(:write)
        .with('source/screen.css', '')
      expect { subject.style }.to output(/Stylesheet rendered/).to_stdout
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
