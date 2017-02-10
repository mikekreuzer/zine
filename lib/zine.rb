require 'erb'
require 'rainbow'
require 'zine/page'
require 'zine/posts_and_headlines'
require 'zine/server'
require 'zine/templates'

module Zine
  # the site
  class Site
    attr_reader :options

    def initialize
      @templates_by_name = {}
      init_options
      clean_option_paths
    end

    def init_options
      @options ||= begin
        YAML.safe_load File.open('zine.yaml')
      rescue ArgumentError => err
        puts Rainbow("Could not parse YAML options: #{err.message}").red
      end
    end

    def init_templates
      tem_array = Dir[File.join(@options['directories']['templates'], '*.erb')]
      tem_array.each do |tem|
        @templates_by_name.merge!(File.basename(tem, '.*') =>
                                  ERB.new(File.read(tem), 0, '-'))
      end
    end

    def build_site
      init_templates
      write_posts_and_headlines
      housekeeping_copy
      write_other_markdown_pages
      preview
    end

    def clean_option_paths
      directories = @options['directories']
      %w(assets posts styles templates).each do |dir|
        directories[dir] = File.join directories['source'], directories[dir]
      end
      directories['blog'] = File.join directories['build'], directories['blog']
    end

    def housekeeping_copy
      directories = @options['directories']
      src_dir = directories['source']
      search = File.join src_dir, '**', '*.*'
      possible = Dir.glob(search, File::FNM_DOTMATCH).reject do |found|
        found =~ /^.+\.md$|^.+\.erb$|^\.DS_Store$|^\.$|^\.\.$'/ ||
          File.directory?(found) || found[directories['posts']] ||
          found[directories['templates']]
      end
      possible.each do |file|
        dir = Pathname(File.dirname(file)).relative_path_from(Pathname(src_dir))
        filename = File.basename file
        dest = File.join directories['build'], dir
        FileUtils.mkdir_p dest
        FileUtils.cp file, File.join(dest, filename)
      end
    end

    def make_template_bundle(type)
      TemplateFiles.new(
        if @templates_by_name.key?(type)
          @templates_by_name[type]
        else
          @templates_by_name['default']
        end,
        @templates_by_name['header_partial'],
        @templates_by_name['footer_partial']
      )
    end

    def preview
      Server.new File.absolute_path(@options['directories']['build'])
    end

    # TODO: structure in common with housekeeping_copy
    def write_other_markdown_pages
      dir_options = @options['directories']
      src_dir = dir_options['source']
      search = File.join src_dir, '**', '*.md'
      default_name = @options['templates']['default']
      Dir[search].reject { |found| found[dir_options['posts']] }.each do |file|
        dir = Pathname(File.dirname(file)).relative_path_from(Pathname(src_dir))
        file_name = "#{File.basename(file, '.*')}.html"
        dest = File.join dir_options['build'], dir
        FileUtils.mkdir_p dest
        page = Zine::Page.new(file, File.join(dest, file_name),
                              make_template_bundle(default_name), @options)
        page.process
      end
    end

    def write_posts_and_headlines
      posts = Zine::PostsAndHeadlines.new self, @options
      posts.write
    end
  end
end
