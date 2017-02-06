module Zine
  # Trio of templates used to create a page
  class TemplateFiles
    attr_reader :body
    attr_reader :footer
    attr_reader :header

    def initialize(body, header, footer)
      @body = body
      @header = header
      @footer = footer
    end
  end
end
