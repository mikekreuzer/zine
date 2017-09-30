require 'highline'
require 'rainbow'
require 'set'
require 'zine'
require 'zine/uploader_github'
require 'zine/uploader_sftp'

module Zine
  # Deploy changes to a remote host, via SFTP or using the GitHub Rest API
  class Upload
    def initialize(build_dir, options, delete_file_array, upload_file_array)
      if options['method'] == 'none'
        @no_upload = true
        return
      end
      @build_dir = build_dir
      @options = options
      cred_file = options['credentials']
      @credentials = read_credentials(cred_file)
      @upload_file_array = Set.new(upload_file_array).to_a
      @delete_file_array = Set.new(delete_file_array).to_a - @upload_file_array
    end

    def upload_decision(query_class)
      return if @no_upload
      cli = query_class.new
      answer = cli.ask('Upload files? (Y/n)') { |q| q.default = 'Y' }
      return if answer != 'Y'
      puts Rainbow('Connecting...').green
      upload
    end

    private

    def parse_yaml(text, cred_file)
      YAML.safe_load text
    rescue Psych::Exception
      puts Rainbow("Could not parse YAML in: #{cred_file}").red
      { 'username' => '', 'password' => '' }
    end

    def read_credentials(cred_file)
      parse_yaml(File.read(cred_file), cred_file)
    rescue Errno::ENOENT
      puts Rainbow('Path to upload credentials missing from zine.yaml').red
      exit
    end

    def github_upload
      uploader = Zine::UploaderGitHub.new(@build_dir,
                                          @options,
                                          @credentials,
                                          @delete_file_array,
                                          @upload_file_array)
      puts '---', uploader.inspect, '---'
      uploader.upload
    end

    def sftp_upload
      uploader = Zine::UploaderSFTP.new(@build_dir,
                                        @options,
                                        @credentials,
                                        @delete_file_array,
                                        @upload_file_array)
      uploader.upload
    end

    def upload
      if @options['method'] == 'sftp'
        sftp_upload
      elsif @options['method'] == 'github'
        github_upload
      else
        puts Rainbow('Unknown upload option in zine.yaml').red
      end
    end
  end
end
