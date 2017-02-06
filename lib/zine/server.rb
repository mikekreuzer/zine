require 'rainbow'
require 'rack'
require 'thin'

module Zine
  # Local preview web server
  class Server
    def initialize(root)
      motd
      Thin::Server.start('127.0.0.1', 8080) do
        use Rack::Static,
            urls: ['/'],
            index: 'index.html',
            root: root

        now = Time.now
        a_long_time = 100**4
        run lambda { |_env|
          [200,
           {
             'Content-Type'  => 'text/html',
             'ETag'          => nil,
             'Last-Modified' => now + a_long_time,
             'Cache-Control' =>
              'no-store, no-cache, must-revalidate, post-check=0, pre-check=0',
             'Pragma'        => 'no-cache',
             'Expires'       => now - a_long_time
           },
           File.open(File.join(root, 'index.html'), File::RDONLY)]
        }
      end
    end

    def motd
      puts "\nPreview running on " +
           Rainbow('http://127.0.0.1:8080/').blue.underline +
           "\nCommand double click the URL to open, Control C to quit\n"
    end
  end
end
