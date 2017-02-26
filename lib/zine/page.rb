require 'erb'
require 'date'
require 'htmlcompressor'
require 'kramdown'
require 'pathname'
require 'rainbow'
require 'yaml'
require 'zine'
require 'zine/templates'

module Zine
  # A page on the site where the content comes from a file's markdown, and the
  # destination's location mirrors its own
  class Page
    attr_reader :dest_path, :formatted_data, :source_file, :template_bundle
    # the meta data, passed formatted to the template
    class FormattedData
      include ERB::Util

      attr_accessor :data
      attr_accessor :footer_partial
      attr_accessor :header_partial
      attr_accessor :html
      attr_reader   :page
      attr_accessor :uri

      def initialize(front_matter, site_opt)
        site = site_opt['options']
        @page = { date_rfc3339: front_matter['date'],
                  date_us: parse_date(front_matter['date']),
                  github_name: site['github_name'],
                  links_array: site_opt['links'],
                  num_items_on_home: site['num_items_on_home'],
                  site_author: site['site_author'],
                  site_description: site['site_description'],
                  site_name: site['site_name'],
                  site_URL: site['site_URL'],
                  tags: slugify_tags(front_matter['tags']),
                  title: html_escape(front_matter['title']),
                  twitter_name: site['twitter_name'] }
      end

      def public_binding
        binding
      end

      private

      def parse_date(front_matter_date)
        DateTime.rfc3339(front_matter_date).strftime('%B %-d, %Y')
      rescue
        ''
      end

      def slugify_tags(tags)
        return unless tags && tags.any?
        tags.map { |tag| { name: tag, tag_slug: Page.slug(tag) } }
      end
    end

    # the Tags on a Post
    TagData = Struct.new(:tagsArray, :destURL, :pageTitle, :pageDate,
                         :pageDateUS)

    def initialize(md_file_name, dest, templates, site_options)
      @source_file = md_file_name
      file_parts = File.open(md_file_name, 'r').read.split('---')
      @formatted_data = FormattedData.new(parse_yaml(file_parts[1],
                                                     md_file_name),
                                          site_options)
      @dest_path = dest
      @raw_text = file_parts[2]
      init_templates(templates)
    end

    def process(string_or_file_writer)
      parse_markdown
      html = template_the_html

      compressor = HtmlCompressor::Compressor.new
      string_or_file_writer.write(@dest_path, compressor.compress(html))
    end

    def self.slug(text)
      text.downcase
          .gsub(/[^a-z0-9]+/, '-')
          .gsub(/^-|-$/, '')
    end

    private

    def init_templates(templates)
      @header_partial = templates.header
      @footer_partial = templates.footer
      @template = templates.body
      @template_bundle = templates
    end

    def parse_markdown
      @formatted_data.html = Kramdown::Document.new(
        @raw_text,
        input: 'GFM',
        auto_ids: false,
        smart_quotes: %w(apos apos quot quot),
        syntax_highlighter: 'rouge'
      ).to_html
      @raw_text = nil
    end

    def parse_yaml(text, md_file_name)
      YAML.safe_load text
    rescue Psych::Exception
      puts Rainbow("Could not parse front matter for: #{md_file_name}").red
      { 'date' => DateTime.now.to_s, 'title' => md_file_name, 'tags' => [] }
    end

    def rel_path_from_build_dir(path)
      full = Pathname(path)
      full.relative_path_from(Pathname(@build_dir))
    end

    def template_the_html
      data_binding = @formatted_data.public_binding
      @formatted_data.header_partial = @header_partial.result data_binding
      @formatted_data.footer_partial = @footer_partial.result data_binding
      @template.result data_binding
    end
  end
end
