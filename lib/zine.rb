require 'erb'
require 'rainbow'
require 'zine/data_page'
require 'zine/page'
require 'zine/post'
require 'zine/server'
require 'zine/tag'
require 'zine/templates'
require 'zine/version'

module Zine
  # the site
  class Site
    attr_reader :options

    def initialize
      @post_array = []
      @templates_by_name = {}
      init_options
      clean_option_paths
      init_templates
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
      read_post_markdown_files
      sort_posts_by_date
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

    def read_post_markdown_files
      file_name_array = Dir[File.join(@options['directories']['posts'], '*.md')]
      post_name = @options['templates']['post']
      file_name_array.each do |file|
        @post_array << Zine::Post.new(file,
                                      make_template_bundle(post_name),
                                      @options)
      end
    end

    def sort_posts_by_date
      @post_array.sort_by! do |post|
        post.formatted_data.page[:date_rfc3339]
      end.reverse!
      @post_array.freeze
    end

    def headline_pages
      dir = @options['directories']['build']
      options = @options['options']
      templates = @options['templates']
      [{ build_dir: dir, name: 'articles', number: @post_array.size,
         suffix: '.html', template_name: templates['articles'],
         title: 'Articles' },
       { build_dir: dir, name: 'index',
         number: options['num_items_on_home'], suffix: '.html',
         template_name: templates['home'], title: 'Home' },
       { build_dir: dir, name: 'rss',
         number: options['number_items_in_RSS'], suffix: '.xml',
         template_name: templates['rss'], title: '' }]
    end

    def wrangle_headlines
      headline_pages.each do |page|
        write_headline page
      end
    end

    def write_headline(page)
      data = page
      data[:post_array] = []
      @post_array.first(page[:number]).each do |post|
        post_data = post.formatted_data
        data[:post_array] << { page: post_data.page, html: post_data.html,
                               uri:  post_data.uri }
      end
      data_page = DataPage.new(data, make_template_bundle(data[:template_name]),
                               @options, data[:suffix])
      data_page.write
    end

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
      tags_by_post = []
      @post_array.each do |post|
        tags_by_post << post.process
      end
      tag_name = @options['templates']['tag']
      tag_index_name = @options['templates']['tag_index']
      tags = Zine::Tag.new tags_by_post, make_template_bundle(tag_name),
                           make_template_bundle(tag_index_name), @options
      tags.write_tags
      wrangle_headlines
    end
  end
end
