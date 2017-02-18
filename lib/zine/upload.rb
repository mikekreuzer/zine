require 'net/ssh'
require 'net/sftp'
require 'rainbow'
require 'set'

module Zine
  # Deploy changes to a remote host
  # TODO: add GitHub deploys as well...
  class Upload
    # a folder in a path
    Node = Struct.new(:name, :path_string)

    def initialize(build_dir, options, delete_file_array, upload_file_array)
      return unless options['method'] == 'sftp'

      @build_dir = build_dir
      @host = options['host']
      @path = options['path']
      @verbose = options['verbose']

      cred_file = options['credentials']
      @credentials = parse_yaml(File.open(cred_file, 'r'), cred_file)

      @upload_file_array = Set.new(upload_file_array).to_a
      @delete_file_array = Set.new(delete_file_array).to_a - @upload_file_array
    end

    def delete
      Net::SFTP.start(@host, @credentials['username'],
                      password: @credentials['password']) do |sftp|
        @delete_file_array.each do |rel_file_path|
          sftp.remove(File.join(@path, rel_file_path)).wait
          puts "Deleted #{rel_file_path}" if @verbose
        end
      end
    end

    def deploy
      Net::SFTP.start(@host, @credentials['username'],
                      password: @credentials['password']) do |sftp|
        deploy_directories sftp
        deploy_files sftp
      end
    end

    private

    def break_strings_into_arrays(paths_array)
      paths_array.map do |dir|
        dir.to_s.split File::SEPARATOR
      end
    end

    # make directories
    def deploy_directories(sftp)
      node_array = make_sparse_node_array @upload_file_array
      node_array.each do |level|
        level.each do |node|
          next if node.nil?
          path_string = node.path_string
          mkdir_p(sftp, path_string)
          puts "mkdir_p #{path_string}" if @verbose
        end
      end
    end

    # upload files
    def deploy_files(sftp)
      @upload_file_array.each do |rel_file_path|
        sftp.upload(File.join(@build_dir, rel_file_path),
                    File.join(@path, rel_file_path),
                    permissions: 0o644).wait # -rw-r--r--
        puts "Uploaded #{rel_file_path}" if @verbose
      end
    end

    def mkdir_p(sftp, path)
      sftp.mkdir!(File.join(@path, path), permissions: 0o755) # drwxr-xr-x
    rescue Net::SFTP::StatusException => error
      raise if error.code != 4 && error.code != 11 # folder already exists
    end

    # make a sparse matrix as a directory tree, to make mkdir calls efficiently
    def make_sparse_node_array(file_array)
      paths_array = remove_filenames file_array           # remove file names
      paths_array = Set.new(paths_array).to_a             # remove duplicates
      paths_array = break_strings_into_arrays paths_array # to array of arrays
      paths_array = strings_to_nodes paths_array          # ...of nodes
      level_array = transpose paths_array                 # arrayed by level
      remove_duplicates level_array                       # make it sparse
    end

    def parse_yaml(text, cred_file)
      YAML.safe_load text
    rescue Psych::Exception
      puts Rainbow("Could not parse YAML in: #{cred_file}").red
      { 'username' => '', 'password' => '' }
    end

    # for each level, if a node has the same name & same path it's a duplicate
    def remove_duplicates(level_array)
      level_array.map do |level|
        length = level.length
        level_copy = level
        level.each_with_index.map do |node, index|
          next if node.nil?
          if index.zero?
            node
          elsif !level_copy[0..(index - 1)]
                .index { |item| same(item, node) }.nil? ||
                !level_copy[(index + 1)..(length - 1)]
                .index { |item| same(item, node) }.nil?
            level_copy[index] = nil
            nil
          else
            node
          end
        end
      end
    end

    # array of file paths to array of directory paths
    def remove_filenames(file_array)
      file_array.map do |file|
        path = File.dirname file
        if path == '.'
          nil
        else
          path
        end
      end
    end

    # equality for a node
    def same(first, second)
      return false if first.nil? || second.nil?
      first.name == second.name && first.path_string == second.path_string
    end

    # convert directory names to nodes with knowledge of their parentage
    def strings_to_nodes(paths_array)
      paths_array.map do |path|
        path_string_array = path
        path.each_with_index.map do |elem, index|
          Node.new(elem, path_string_array[0..index].join(File::SEPARATOR))
        end
      end
    end

    # flip it, to get directories by level in a path, rather than by path
    def transpose(input)
      result = []
      max_size = input.max_by(&:size).size
      max_size.times do |i|
        result[i] = Array.new(input.first.size)
        input.each_with_index { |r, j| result[i][j] = r[i] }
      end
      result
    end
  end
end
