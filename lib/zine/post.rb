require 'uri'

module Zine
  # A post - content comes from the markdown, and the destination from the date
  class Post < Page
    def initialize(md_file_name, templates, site_options)
      @source_file = md_file_name
      file_parts = File.open(md_file_name, 'r').read.split('---')
      @formatted_data = FormattedData.new(parse_yaml(file_parts[1]),
                                          site_options)
      @raw_text = file_parts[2]
      init_templates(templates)
      option_dir = site_options['directories']
      @build_dir = option_dir['build'] # for tags
      @dest_path = make_path_from_date option_dir['blog']
    end

    def make_path_from_date(build_dir)
      page_data = @formatted_data.page
      date = DateTime.parse(page_data[:date_rfc3339])
      dest_dir = File.join(build_dir,
                           date.strftime('%Y'),
                           date.strftime('%-m'))
      FileUtils.mkdir_p dest_dir
      slg = Zine::Page.slug(page_data[:title]) + '.html'
      @dest_path = File.join(dest_dir, slg)
    end

    def process
      super
      page_data = @formatted_data.page
      file_path = rel_path_from_build_dir(@dest_path).to_s
      @formatted_data.uri = URI.join(page_data[:site_URL], file_path).to_s
      TagData.new(page_data[:tags],
                  file_path,
                  page_data[:title],
                  page_data[:date_rfc3339],
                  page_data[:date_us])
    end
  end
end
