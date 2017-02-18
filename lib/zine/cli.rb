require 'thor'
require 'rainbow'
require 'time'
require 'yaml'
require 'zine'
require 'zine/style'
require 'zine/version'

module Zine
  # CLI for zine
  class CLI < Thor
    include Thor::Actions

    no_commands do
      def init_site
        @site ||= Zine::Site.new
      end
    end

    desc 'build', 'Build the site'
    def build
      init_site
      @site.build_site
      puts Rainbow('Site built').green
    end

    desc 'force', 'Build the site, forcing writes & uploads'
    def force
      init_site
      @site.build_site_forcing_writes
      puts Rainbow('Site built').green
    end

    desc 'nuke', 'Delete the build folder'
    def nuke
      init_site
      FileUtils.remove_dir @site.options['directories']['build'], force: true
      puts Rainbow('Site nuked. It\'s the only way to be sure.').green
    end

    desc 'post TITLE', 'Create the file for a new blog post, titled TITLE'
    def post(name)
      init_site
      option_dir = @site.options['directories']
      Zine::CLI.source_root option_dir['templates']
      @date = DateTime.now
      @name = name
      file = "#{@date.strftime('%Y-%m-%d')}-#{Zine::Page.slug(name)}.md"
      new_post_name = @site.options['templates']['new_post']
      template new_post_name,
               File.join(Dir.pwd, option_dir['posts'], file)
    end

    desc 'site', 'Create the skeleton of a new site (overwriting files)'
    def site
      @skeleton_dir = File.join File.dirname(__FILE__), 'skeleton', '/.'
      FileUtils.cp_r @skeleton_dir, Dir.pwd
      puts Rainbow('New skeleton site created').green
    end

    desc 'style', 'Build the site\'s stylesheet'
    def style
      init_site
      style = Zine::Style.new(@site.options['directories'])
      style.process
      puts Rainbow('Stylesheet rendered').green
    end

    desc 'version', 'Show the version number'
    def version
      puts VERSION
    end
  end
end
