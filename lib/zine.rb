require 'erb'
require 'rainbow'
require 'zine/page'
require 'zine/posts_and_headlines'
require 'zine/server'
require 'zine/templates'

module Zine
  # the site
  class Site
    # Site options read from YAML during the initialisation of the class
    attr_reader :options

    # Create a new instance of Site, called by CLI#init_site
    def initialize
      @templates_by_name = {}
      init_options
      clean_option_paths
    end

    # A dry run build that generates baseline data to compare changes to during
    # editting/preview, then generate files where the source files change.
    # Called by CLI#build
    def build_site
      init_templates
      FileUtils.mkdir_p @options['directories']['build']
      # posts_and_guard is { posts: @post_array, guard: @guard }
      posts_and_guard = posts_and_headlines_without_writing
      preview posts_and_guard
    end

    # Build the files of the site, generating files immeadiately, suitable for
    # the initial build or complete rebuild.
    # Called by CLI#force
    def build_site_forcing_writes
      init_templates
      FileUtils.mkdir_p @options['directories']['build']
      # posts_and_guard is { posts: @post_array, guard: @guard }
      posts_and_guard = write_posts_and_headlines
      housekeeping
      write_other_markdown_pages
      preview posts_and_guard
    end

    # Create a new instance of TemplateFiles, looking up the body template in
    # @templates_by_name, defaults to the template named 'default'
    #
    # Called in PostsAndHeadlines.read_post_markdown_files,
    # PostsAndHeadlines.one_new_post, PostsAndHeadlines.write_headline,
    # PostsAndHeadlines.write_tags_and_headlines
    #
    # ==== Attributes
    #
    # * +type+ - The name of the template used for the body eg post
    #
    # ==== Eg
    #
    #    make_template_bundle 'post'
    #
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

    # currently used to say yes on a script's behalf - in #notice
    class MockHighlineYes
      def ask(_question)
        'Y'
      end
    end

    # Build the site, noticing this file as having changed
    # Called by CLI#notice
    # TODO: common function call across other methods
    def notice(file)
      # build
      init_templates
      FileUtils.mkdir_p @options['directories']['build']
      # posts_and_headlines_without_writing
      posts = Zine::PostsAndHeadlines.new self, @options # starts watcher
      posts_and_guard = posts.writeless
      guard = posts_and_guard[:guard]

      # build the file & add it to the upload array
      posts_dir = @options['directories']['posts']
      file_to_notice = File.join posts_dir, file
      path_to_notice = File.join Dir.getwd, file_to_notice

      dest_path = posts.one_new_post file_to_notice, path_to_notice
      guard.notice(dest_path)

      # TODO: everywhere
      guard.listener_array.each(&:stop)

      # preview posts_and_guard -- no preview needed...
      return if @options['upload']['method'] == 'none' ||
                (guard.delete_array.empty? && guard.upload_array.empty?)
      uploader = Zine::Upload.new @options['directories']['build'],
                                  @options['upload'],
                                  guard.delete_array,
                                  guard.upload_array
      uploader.upload_decision MockHighlineYes
    end

    def write_markdown(default_name, src_dir, file)
      dir = Pathname(File.dirname(file)).relative_path_from(Pathname(src_dir))
      file_name = "#{File.basename(file, '.*')}.html"
      dest = File.join @options['directories']['build'], dir
      FileUtils.mkdir_p dest
      page = Zine::Page.new(file, File.join(dest, file_name),
                            make_template_bundle(default_name), @options)
      page.process File
    end

    private

    def clean_option_paths
      directories = @options['directories']
      %w[assets posts styles templates].each do |dir|
        directories[dir] = File.join directories['source'], directories[dir]
      end
      directories['blog'] = File.join directories['build'], directories['blog']
    end

    def housekeeping
      directories = @options['directories']
      source_directory = directories['source']
      search = File.join source_directory, '**', '*.*'
      possible = Dir.glob(search, File::FNM_DOTMATCH).reject do |found|
        housekeeping_files_not_to_copy found, directories
      end
      possible.each do |file|
        housekeeping_copy(file, source_directory, directories['build'])
      end
    end

    def housekeeping_files_not_to_copy(found, directories)
      found =~ /^.+\.md$|^.+\.erb$|^\.DS_Store$|^\.$|^\.\.$'/ ||
        File.directory?(found) ||
        found[directories['posts']] ||
        found[directories['templates']] ||
        found[directories['styles']]
    end

    def housekeeping_copy(file, src_dir, build_dir)
      dir = Pathname(File.dirname(file)).relative_path_from(Pathname(src_dir))
      filename = File.basename file
      dest = File.join build_dir, dir
      FileUtils.mkdir_p dest
      FileUtils.cp file, File.join(dest, filename)
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

    # Generate data without writing files (for incremental builds & uploads)
    # returns posts & guard to use during edits under preview
    def posts_and_headlines_without_writing
      posts = Zine::PostsAndHeadlines.new self, @options
      posts.writeless
    end

    def preview(posts_and_guard)
      guard = posts_and_guard[:guard]
      Server.new @options['directories']['build'], @options['upload'],
                 guard.delete_array, guard.upload_array
    end

    def write_other_markdown_pages
      dir_options = @options['directories']
      src_dir = dir_options['source']
      search = File.join src_dir, '**', '*.md'
      default_name = @options['templates']['default']
      Dir[search].reject { |found| found[dir_options['posts']] }.each do |file|
        write_markdown(default_name, src_dir, file)
      end
    end

    # returns posts & guard to use during edits under preview
    def write_posts_and_headlines
      posts = Zine::PostsAndHeadlines.new self, @options
      posts.write
    end
  end
end
