require 'net/ssh'
require 'net/sftp'
require 'rainbow'
require 'set'

module Zine
  # Deploy changes to a remote host, using SFTP
  # TODO: add GitHub deploys as well...
  class Upload
    # a folder in a path
    Node = Struct.new(:name, :path_string)

    def initialize(build_dir, options)
      return unless options['method'] == 'sftp'
      cred_file = options['credentials']
      credentials = parse_yaml(File.open(cred_file, 'r'), cred_file)

      @build_dir = build_dir
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

    # TODO: consolidate these for duplicates
    def delete(file_array)
      Net::SFTP.start(@host, @username, password: @password) do |sftp|
        file_array.each do |rel_file_path|
          sftp.remove(File.join(@path, rel_file_path)).wait
          puts "Deleted #{rel_file_path}" if @verbose
        end
      end
    end

    def deploy(upload_file_array)
      Net::SFTP.start(@host, @username, password: @password) do |_sftp|
        # remove duplicates
        file_array = Set.new(upload_file_array).to_a
        # make directories
        node_array = make_sparse_node_array file_array
        node_array.each do |level|
          level.each do |node|
            next if node.nil?
            mkdir_p(sftp, node.path_string)
            puts "mkdir_p #{node.path_string}"
          end
        end
        # upload files
        file_array.each do |rel_file_path|
          sftp.upload(File.join(@build_dir, rel_file_path),
                      File.join(@path, rel_file_path),
                      permissions: 0o644).wait # -rw-r--r--
          puts "Uploaded #{rel_file_path}" if @verbose
        end
      end
    end

    private

    def break_strings_into_arrays(paths_array)
      paths_array.map do |dir|
        dir.to_s.split File::SEPARATOR
      end
    end

    def mkdir_p(sftp, path)
      sftp.mkdir!(path, permissions: 0o755) # drwxr-xr-x
    rescue Net::SFTP::StatusException => e
      raise if e.code != 4 && e.code != 11  # because folder already exists
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

    # for each level, if a node has the same name & same path it's a duplicate
    def remove_duplicates(level_array)
      level_array.map do |level|
        level_array = level
        level.each_with_index.map do |node, index|
          next if node.nil?
          if index.zero?
            node
          elsif !level_array[0..index - 1].index { |item| same(item, node) }.nil? ||
                !level_array[index + 1..level_array.length].index { |item| same(item, node) }.nil?
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
    def same(a, b)
      return false if a.nil? || b.nil?
      a.name == b.name && a.path_string == b.path_string
    end

    # convert directory names to nodes with knowledge of their parentage
    def strings_to_nodes(paths_array)
      paths_array.map do |path|
        path_string_array = path
        path.each_with_index.map do |elem, i|
          Node.new(elem, path_string_array[0..i].join(File::SEPARATOR))
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
