require 'erb'
require 'rainbow'
require 'zine/data_page'
require 'zine/page'
require 'zine/feed'
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
      write_posts
      housekeeping_copy
      write_other_markdown_pages
      write_feed
      preview
    end

    def clean_option_paths
      %w(assets posts styles templates).each do |dir|
        @options['directories'][dir] =
          File.join @options['directories']['source'],
                    @options['directories'][dir]
      end
      @options['directories']['blog'] =
        File.join @options['directories']['build'],
                  @options['directories']['blog']
    end

    def housekeeping_copy
      src_dir = @options['directories']['source']
      search = File.join src_dir, '**', '*.*'
      dir_options = @options['directories']
      possible = Dir.glob(search, File::FNM_DOTMATCH).reject do |found|
        found =~ /^.+\.md$|^.+\.erb$|^\.DS_Store$|^\.$|^\.\.$'/ ||
          File.directory?(found) || found[dir_options['posts']] ||
          found[dir_options['templates']]
      end
      possible.each do |file|
        dir = Pathname(File.dirname(file)).relative_path_from(Pathname(src_dir))
        filename = File.basename file
        dest = File.join @options['directories']['build'], dir
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
      file_name_array.each do |file|
        @post_array << Zine::Post.new(file,
                                      make_template_bundle('post'),
                                      @options)
      end
    end

    def sort_posts_by_date
      @post_array.sort_by! do |post|
        post.formatted_data.page[:date_rfc3339]
      end.reverse!
      @post_array.freeze
    end

    def write_feed
      number = @options['options']['number_items_in_RSS']
      feed = Zine::Feed.new(@post_array.first(number), @options)
      feed.process
    end

    def write_homepage
      homepage_data = { build_dir: @options['directories']['build'],
                        name: 'index', title: 'Home', post_array: [] }
      @post_array.first(@options['options']['num_items_on_home']).each do |post|
        homepage_data[:post_array] << { page: post.formatted_data.page,
                                        html: post.formatted_data.html }
      end
      home_page = DataPage.new(homepage_data, make_template_bundle('home'),
                               @options)
      home_page.write
    end

    def write_other_markdown_pages
      dir_options = @options['directories']
      src_dir = dir_options['source']
      search = File.join src_dir, '**', '*.md'
      Dir[search].reject { |found| found[dir_options['posts']] }.each do |file|
        dir = Pathname(File.dirname(file)).relative_path_from(Pathname(src_dir))
        file_name = "#{File.basename(file, '.*')}.html"
        dest = File.join dir_options['build'], dir
        FileUtils.mkdir_p dest
        page = Zine::Page.new(file, File.join(dest, file_name),
                              make_template_bundle('default'), @options)
        page.process
      end
    end

    def write_posts
      tags_by_post = []
      @post_array.each do |post|
        tags_by_post << post.process
      end
      tags = Zine::Tag.new tags_by_post, make_template_bundle('tag'),
                           make_template_bundle('tag_index'), @options
      tags.write_tags
      write_homepage
    end
  end
end
