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
      read_post_markdown_files
      sort_posts_by_date
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
      @post_array.freeze
    end

    # The headlines pages - the home page, an articles index, and RSS feed
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

    # Process each of the headlines pages
    def wrangle_headlines
      headline_pages.each do |page|
        write_headline page
      end
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

    # Write out the Posts
    def write
      tags_by_post = []
      @post_array.each do |post|
        tags_by_post << post.process
      end
      tag_name = @options['templates']['tag']
      tag_index_name = @options['templates']['tag_index']
      tags = Zine::Tag.new tags_by_post, @site.make_template_bundle(tag_name),
                           @site.make_template_bundle(tag_index_name), @options
      tags.write_tags
      wrangle_headlines
    end
  end
end
