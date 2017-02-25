require 'rainbow'
require 'rack'
require 'thin'
require 'zine/upload'
require 'zine/watcher'

module Zine
  # Local preview web server
  class Server
    def initialize(rel_path_build, upload_options, delete_array, upload_array)
      @delete_array = delete_array
      @upload_array = upload_array
      @thin = create_server File.absolute_path(rel_path_build)
      motd unless upload_options['test']
      @thin.start
      possible_upload rel_path_build, upload_options
      @thin
    end

    # stop the server - only used in testing
    def stop
      @thin.stop
    end

    private

    def create_server(root)
      rules = header_rules
      Thin::Server.new('127.0.0.1', 8080) do
        use Rack::Static,
            urls: ['/'],
            index: 'index.html',
            root: root,
            header_rules: rules
        run ->(_env) { [200, {}, ['Have to call run...']] }
      end
    end

    def header_rules
      [[:all,
        { 'ETag'          => nil,
          'Last-Modified' => (Time.now + 100**4).to_s,
          'Cache-Control' =>
            'no-store, no-cache, must-revalidate, post-check=0, pre-check=0',
          'Pragma'        => 'no-cache',
          'Expires'       => (Time.now - 100**4).to_s }]]
    end

    def motd
      puts "\nPreview running on " +
           Rainbow('http://127.0.0.1:8080/').blue.underline +
           "\nCommand double click the URL to open, Control C to quit\n"
    end

    def possible_upload(rel_path_build, upload_options)
      return if upload_options['method'] == 'none' ||
                (@delete_array.empty? && @upload_array.empty?)
      uploader = Zine::Upload.new rel_path_build, upload_options,
                                  @delete_array, @upload_array
      uploader.upload_decision
    end
  end
end
