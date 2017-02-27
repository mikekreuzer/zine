require 'spec_helper'
require 'zine'
require 'zine/page'
require 'zine/templates'

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

  describe '#new' do
    class MockFile
      def self.write(path, content)
        { path: path, content: content }
      end
    end
    before(:all) do
      skeleton_dir = File.join('..', '..', 'lib', 'zine', 'skeleton')
      @skeleton_about_file = File.expand_path(File.join(skeleton_dir, 'source',
                                                        'about.md'),
                                              __FILE__)
      skeleton_option_file = File.expand_path(File.join(skeleton_dir,
                                                        'zine.yaml'),
                                              __FILE__)
      skeleton_template_dir = File.expand_path(File.join(skeleton_dir, 'source',
                                                         'templates'),
                                               __FILE__)
      @head = File.read(File.join(skeleton_template_dir, 'header_partial.erb'))
      foot = File.read(File.join(skeleton_template_dir, 'footer_partial.erb'))
      body = File.read(File.join(skeleton_template_dir, 'default.erb'))
      @options = YAML.safe_load File.open skeleton_option_file
      @template_bundle = Zine::TemplateFiles.new(ERB.new(@head),
                                                 ERB.new(body),
                                                 ERB.new(foot))
      @page = Zine::Page.new @skeleton_about_file,
                             File.join(Dir.pwd, 'temp.html'),
                             @template_bundle,
                             @options
    end

    it 'creates an instance of Page' do
      expect(@page).to be_instance_of(Zine::Page)
    end

    context 'for a page file with no front matter divider' do
      it 'throws an error' do
        expect do
          Zine::Page.new @head, # ie not a file with frontmatter
                         File.join(Dir.pwd, 'temp.html'),
                         @template_bundle,
                         @options
        end.to raise_error(Errno::ENAMETOOLONG)
      end
    end

    context 'with badly formed front matter' do
      it 'creates a Page object with default meta values & outputs a warning' do
        allow(File)
          .to receive(:open)
          .with('bad.md', 'r')
          .and_return(
            StringIO.new("---quote: '2017-02-26T21:01:03+11:00\n---\n\nStuff")
          )
        expect do
          page = Zine::Page.new 'bad.md',
                                File.join(Dir.pwd, 'temp.html'),
                                @template_bundle,
                                @options
          expect(page).to be_instance_of(Zine::Page)
        end.to output(/Could not parse front matter for: bad.md/).to_stdout
      end
    end

    describe '#process' do
      it 'writes html to the right file' do
        expected_content =
          '<!DOCTYPE html> <html lang="en"> <head> <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,user-scalable=yes">
          <meta name="description" content="The scribblings of a once and
          future code monkey"> <title>Mike Kreuzer | About</title> <link
          rel="home" href="https://mikekreuzer.com/rss.xml"
          type="application/rss+xml" title="Mike Kreuzer">
          <link rel="stylesheet" href="/screen.css"> <link
          rel="apple-touch-icon" href="/apple-touch-icon.png"> </head> <body>
          <div id="skiptocontent"> <a href="#maincontent">Skip to main
          content</a> </div> <header> <div class="logo"></div> <h1><a
          href="https://mikekreuzer.com">Mike Kreuzer</a></h1> <nav> <ul>
          <li><a href="https://mikekreuzer.com">Home</a></li>
          <li><a href="/articles.html">Articles</a></li> <li><a
          href="/about.html">About</a></li> </ul><a
          href="https://twitter.com/mikekreuzer" class="button
          twitter">Argue with me on Twitter</a><a
          href="https://mikekreuzer.com/rss.xml" rel="home"
          type="application/rss+xml" class="button rss">RSS Feed</a>
          </nav> </header> <a name="maincontent"></a>'.gsub(/\s{2,}/, ' ')
        path_string = File.join(Dir.pwd, 'temp.html')
        output = @page.process MockFile
        expect(output).to eql(path: path_string, content: expected_content)
      end
    end
  end
end
