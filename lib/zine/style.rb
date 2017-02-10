require 'sassc'

module Zine
  # Render sass into CSS in the source directory, to be copied later
  class Style
    # Source & destination files
    def initialize(directories)
      @style_file = File.join directories['styles'], 'screen.scss'
      @css_file = File.join directories['source'], 'screen.css'
    end

    # Write the CSS file
    def process
      sass = File.open(@style_file, 'r').read
      css = SassC::Engine.new(sass, style: :compressed).render
      File.write @css_file, css
    end
  end
end
