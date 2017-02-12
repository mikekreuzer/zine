require 'highline'
require 'rainbow'
require 'rack'
require 'thin'
require 'zine/upload'
require 'zine/watcher'

module Zine
  # Local preview web server
  class Server
    def initialize(posts, rel_path_build, rel_path_source, upload_options)
      root = File.absolute_path(rel_path_build)
      motd
      start_file_watcher(posts, rel_path_build, rel_path_source)

      @thin = Thin::Server.new('127.0.0.1', 8080) do
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
      @thin.start

      return if upload_options['method'] == 'none'
      cli = HighLine.new
      answer = cli.ask('Upload files? (Y/n)') { |q| q.default = 'Y' }
      return if answer != 'Y'
      file_upload upload_options
    end

    # deploy via SFTP
    def file_upload(upload_options)
      puts Rainbow('Connecting...').green
      upload = Zine::Upload.new upload_options
      begin
        upload.delete @guard.delete_array
        upload.deploy @guard.upload_array
      rescue Errno::ENETUNREACH
        puts Rainbow("Unable to connect to #{upload_options['host']}").red
      rescue Net::SSH::AuthenticationFailed
        puts Rainbow("Authentication failed for #{upload_options['host']}").red
        puts 'Check your credential file, and maybe run ssh-add?'
      end
    end

    def start_file_watcher(posts, rel_build, rel_source)
      @guard = Zine::Watcher.new posts, rel_build, rel_source
      @guard.start
    end

    def motd
      puts "\nPreview running on " +
           Rainbow('http://127.0.0.1:8080/').blue.underline +
           "\nCommand double click the URL to open, Control C to quit\n"
    end
  end
end
