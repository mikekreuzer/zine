require 'net/ssh'
require 'net/sftp'
require 'rainbow'

module Zine
  # Deploy changes to a remote host, using SFTP
  # TODO: add GitHub deploys as well...
  class Upload
    def initialize(options)
      return unless options['method'] == 'sftp'
      cred_file = options['credentials']
      credentials = parse_yaml(File.open(cred_file, 'r'), cred_file)

      @host = options['host']
      @path = options['path']
      @username = credentials['username']
      @password = credentials['password']
      @verbose = options['verbose']
    end

    def parse_yaml(text, cred_file)
      YAML.safe_load text
    rescue Psych::Exception
      puts Rainbow("Could not parse YAML in: #{cred_file}").red
      { 'username' => '', 'password' => '' }
    end

    def delete(file_array)
      Net::SFTP.start(@host, @username, password: @password) do |sftp|
        file_array.each do |rel_file_path|
          sftp.remove(File.join(@path, rel_file_path)).wait
          puts "Deleted #{rel_file_path}" if @verbose
        end
      end
    end

    def deploy(file_array)
      Net::SFTP.start(@host, @username, password: @password) do |sftp|
        file_array.each do |rel_file_path|
          mkdir_p(sftp, File.dirname(rel_file_path))
          sftp.upload(File.join('build', rel_file_path),
                      File.join(@path, rel_file_path),
                      permissions: 0o644).wait # -rw-r--r--
          puts "Uploaded #{rel_file_path}" if @verbose
        end
      end
    end

    private

    def mkdir_p(sftp, new_path)
      # split path
      directory_string = new_path.to_s
      folders = directory_string.split(File::SEPARATOR).map do |x|
        x == '' ? File::SEPARATOR : x
      end
      # try sftp.mkdir for each level of the folder hierearchy
      if folders.length != 1
        folders.reduce do |memo, part|
          memo = File.join @path, memo if memo == folders[0]
          try_mkdir sftp, memo
          memo = File.join memo, part
        end
      end
      try_mkdir(sftp, File.join(@path, new_path))
    end

    def try_mkdir(sftp, path)
      sftp.mkdir!(path, permissions: 0o755) # drwxr-xr-x
    rescue Net::SFTP::StatusException => e
      raise if e.code != 4 && e.code != 11 # folder already exists
    end
  end
end
