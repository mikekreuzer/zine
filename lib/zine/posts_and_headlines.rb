require 'zine/data_page'
require 'zine/post'
require 'zine/tag'

module Zine
  # The blog posts and their associate headline files (the home page, an
  # articles index, and RSS feed)
  class PostsAndHeadlines
    def initialize(site, options)
      @options = options
      @post_array = []
      @site = site
      @tags_by_post = []
      dir = @options['directories']
      @guard = Zine::Watcher.new self, dir['build'], dir['source']
      @guard.start
      read_post_markdown_files
      sort_posts_by_date
    end

    def find_page_from_path(file_path)
      post_to_rebuild = @post_array.detect do |post|
        File.expand_path(post.source_file) == file_path
      end
      index = @post_array.find_index post_to_rebuild
      { post: post_to_rebuild, index: index }
    end

    # The headlines pages - the home page, an articles index, and RSS feed
    def headline_pages
      dir = @options['directories']['build']
      options = @options['options']
      templates = @options['templates']
      [{ build_dir: dir, name: templates['articles'], number: @post_array.size,
         suffix: '.html', template_name: templates['articles'],
         title: 'Articles' },
       { build_dir: dir, name: 'index',
         number: options['num_items_on_home'], suffix: '.html',
         template_name: templates['home'], title: 'Home' },
       { build_dir: dir, name: 'rss',
         number: options['number_items_in_RSS'], suffix: '.xml',
         template_name: templates['rss'], title: '' }]
    end

    def one_new_post(source_file)
      post_name = @options['templates']['post']
      @post_array << Zine::Post.new(source_file,
                                    @site.make_template_bundle(post_name),
                                    @options)
      @tags_by_post << @post_array.last.process(File)
      # TODO: may need to reorder posts by date, and therefor redo tags
      write_tags_and_headlines
    end

    # get build file from post or location, delete build, remove form post_array
    def preview_delete(file_path)
      page = find_page_from_path file_path
      if page[:index].nil?
        directories = @options['directories']
        full = Pathname(file_path)
        relative = full.relative_path_from(
          Pathname(File.absolute_path(directories['source']))
        )
        relative_path = File.dirname(relative)
        file = File.basename(relative, '.md') + '.html'
        File.delete(File.join(directories['build'], relative_path, file))
      else
        File.delete(page[:post].dest_path)
        @post_array.delete_at(page[:index])
      end
    end

    def preview_rebuild(file_path)
      page = find_page_from_path file_path
      if page[:index].nil?
        if File.dirname(file_path) ==
           File.absolute_path(@options['directories']['posts'])
          one_new_post file_path
        else
          rebuild_page file_path
        end
      else
        rebuild_post page[:post], page[:index]
      end
    end

    # the build folder equivalent of a non Markdown file in the source tree
    # TODO: move from posts & headlines
    def preview_relative_equivalent(file)
      directories = @options['directories']
      source_dir = Pathname(File.absolute_path(directories['source']))
      build_dir = Pathname(File.absolute_path(directories['build']))
      file_dir = Pathname(File.dirname(file))
      File.join build_dir, file_dir.relative_path_from(source_dir)
    end

    # copy a non Markdown file, TODO: move form posts & headlines
    def preview_straight_copy(file)
      FileUtils.cp(file, preview_relative_equivalent(file))
    end

    # delete a non Markdown file, TODO: move form posts & headlines
    def preview_straight_delete(file)
      FileUtils.rm(File.join(
                     preview_relative_equivalent(file), File.basename(file)
      ))
    end

    # rebuild a page that's not a post - doesn't create the file structure for a
    # new file with new parent folders
    def rebuild_page(file)
      @site.write_markdown(@options['templates']['default'],
                           File.expand_path(@options['directories']['source']),
                           file)
    end

    # inserts the new post into the @post_array, builds the file, calls
    # write_tags_and_headlines to rewrites the headline pages & tags
    # RSS & home page will be redundant re-builds if not a recent page
    def rebuild_post(post, index)
      @post_array[index] = Zine::Post.new post.source_file,
                                          post.template_bundle, @options
      @tags_by_post[index] = @post_array[index].process File
      write_tags_and_headlines
      # TODO: may need to reorder posts by date... means re-doing tags
    end

    # Read markdown files in the posts folder into an array of Posts
    def read_post_markdown_files
      file_name_array = Dir[File.join(@options['directories']['posts'], '*.md')]
      post_name = @options['templates']['post']
      file_name_array.each do |file|
        @post_array << Zine::Post.new(file,
                                      @site.make_template_bundle(post_name),
                                      @options)
      end
    end

    # Sort the Posts array into date order, newest first
    def sort_posts_by_date
      @post_array.sort_by! do |post|
        post.formatted_data.page[:date_rfc3339]
      end.reverse!
      # TODO: .freeze -- currently modified during preview
    end

    # Process each of the headlines pages
    def wrangle_headlines
      headline_pages.each do |page|
        write_headline page
      end
    end

    # Write out the Posts, calls write_tags_and_headlines
    def write
      @tags_by_post = []
      @post_array.each do |post|
        @tags_by_post << post.process(File)
      end
      write_tags_and_headlines

      # end point
      { posts: @post_array, guard: @guard }
    end

    # Generate data without writing files (for incremnetal builds & uploads)
    def writeless
      @tags_by_post = []
      @post_array.each do |post|
        @tags_by_post << post.process_without_writing
      end

      # end point
      { posts: @post_array, guard: @guard }
    end

    # Pass headline data to the DataPage class to write the files
    def write_headline(page)
      data = page
      data[:post_array] = []
      @post_array.first(page[:number]).each do |post|
        post_data = post.formatted_data
        data[:post_array] << { page: post_data.page, html: post_data.html,
                               uri:  post_data.uri }
      end
      data_page = DataPage.new(data,
                               @site.make_template_bundle(data[:template_name]),
                               @options, data[:suffix])
      data_page.write
    end

    # Write out the tags and headline files
    def write_tags_and_headlines
      tag_name = @options['templates']['tag']
      tag_index_name = @options['templates']['tag_index']
      tags = Zine::Tag.new @tags_by_post, @site.make_template_bundle(tag_name),
                           @site.make_template_bundle(tag_index_name), @options
      tags.write_tags
      wrangle_headlines
    end
  end
end
