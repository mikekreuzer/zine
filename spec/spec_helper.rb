$LOAD_PATH.unshift File.expand_path(File.join('..', '..', 'lib'), __FILE__)

require 'simplecov'
SimpleCov.start do
  add_filter do |source_file|
    File.dirname(source_file.filename).eql? File.dirname(__FILE__)
  end
end

require 'zine'

# Passed to write methods in place of File to generate a string, not a file
class MockFile
  def self.write(path, content)
    { path: path, content: content }
  end
end
