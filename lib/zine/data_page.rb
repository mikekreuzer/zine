require 'zine/page'

module Zine
  # A page where the content comes from an array, usually an array of
  # links to other pages, eg an index page like the home page
  class DataPage < Zine::Page
    def initialize(data, templates, site_options)
      init_templates(templates)
      @formatted_data = FormattedData.new({}, site_options)
      @formatted_data.page[:title] = data[:title]
      @formatted_data.data = data[:post_array]
      @dest_path = File.join(data[:build_dir],
                             Zine::Page.slug(data[:name]) + '.html')
      write
    end

    def write
      html = template_the_html
      compressor = HtmlCompressor::Compressor.new
      File.write(@dest_path, compressor.compress(html))
    end
  end
end
