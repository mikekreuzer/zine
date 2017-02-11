require 'zine/data_page'

module Zine
  # Posts' tags
  class Tag
    def initialize(tags_by_post, tag_templates, tag_index_templates, options)
      @options = options
      @posts_by_tag = sort_tags tags_by_post
      @templates = { tag: tag_templates, tag_index: tag_index_templates }
      @tag_dir = File.join @options['directories']['build'], 'tags'
      FileUtils.remove_dir @tag_dir, force: true
      FileUtils.mkdir_p @tag_dir
    end

    def write_tags
      @posts_by_tag.each do |tag_name, struct_array|
        sorted_array = sort_tags_by_date struct_array
        data = { name: tag_name, title: 'Tags: ' + tag_name,
                 post_array: sorted_array, build_dir: @tag_dir }
        tag_page = Zine::DataPage.new(data, @templates[:tag], @options)
        tag_page.write
      end
      write_tag_index
    end

    private

    # Take an array of posts each with the tags it has, & make an array of tags,
    # each with the posts it's in
    def sort_tags(tags_by_post)
      posts_by_tag = {}
      tags_by_post.each do |post|
        post['tagsArray'].each do |tag|
          name = tag[:name]
          if posts_by_tag.key?(name)
            posts_by_tag[name] << post
          else
            posts_by_tag[name] = [post]
          end
        end
      end
      posts_by_tag
    end

    def sort_tags_by_date(tag_array)
      tag_array.sort_by do |post|
        post[:pageDate]
      end.reverse!
    end

    def write_tag_index
      tag_index_data = { build_dir: @tag_dir, name: 'index', title: 'All tags',
                         post_array: @posts_by_tag.sort_by { |key, _v| key } }
      tag_index = DataPage.new(tag_index_data, @templates[:tag_index], @options)
      tag_index.write
    end
  end
end
