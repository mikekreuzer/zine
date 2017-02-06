require 'rss'
require 'uri'
# require 'zine/page'

module Zine # < Zine::Page
  # produce the RSS/Atom feed for the site
  class Feed
    def initialize(post_array, options)
      @post_array = post_array
      @options = options['options']
      @rss = create_rss
      @dest_path = File.join(options['directories']['build'], 'rss.xml')
    end

    def create_rss
      RSS::Maker.make('atom') do |maker|
        maker.channel.author = @options['site_author']
        maker.channel.updated = @post_array[0].formatted_data
                                              .page[:date_rfc3339].to_s
        maker.channel.about = (URI.join @options['site_URL'], 'rss.xml').to_s
        maker.channel.title = @options['site_name']

        @post_array.each do |post|
          maker.items.new_item do |item|
            data = post.formatted_data
            meta = data.page
            item.link = data.uri
            item.title = meta[:title]
            item.updated = meta[:date_rfc3339].to_s
            # item.content.content = data.html
            # item.content.type = 'html'
            # =><content type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">
            item.content.type = 'xhtml'
            item.content.xml_content = data.html
          end
        end
      end # rss
    end # fn

    def process
      File.write(@dest_path, @rss)
    end
  end
end
