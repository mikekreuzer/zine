require 'listen'
require 'pathname'

module Zine
  # Watch files for changes
  class Watcher
    attr_reader :upload_array, :delete_array
    attr_accessor :listener_array

    def initialize(posts_and_headlines, build_directory, source_directory)
      @posts_and_headlines = posts_and_headlines
      @build_directory = File.join Dir.pwd, build_directory
      @source_directory = File.join Dir.pwd, source_directory
      @upload_array = []
      @delete_array = []
      @listener_array = []
    end

    def notice(file_name)
      @upload_array << file_name
    end

    # Build a delete list & an upload list for SSH from changes in build,
    # & rebuild & reload on changes in source
    def start
      watch_build_dir
      watch_source_dir
    end

    private

    def on_build_change(path_string_array)
      path_string_array.each do |str|
        rel_path = rel_path_from_build_dir str
        @upload_array << rel_path
      end
    end

    def on_build_delete(path_string_array)
      path_string_array.each do |str|
        rel_path = rel_path_from_build_dir str
        @delete_array << rel_path
        # @upload_array.delete rel_path
      end
    end

    def rel_path_from_build_dir(path)
      full = Pathname(path)
      full.relative_path_from(Pathname(@build_directory))
    end

    # rebuild the file, and the headline files & tags
    # TODO: moves within the watched directory won't delete the old location
    def on_source_change(path)
      path.each do |file|
        if !file.nil? && (file =~ /^.+\.md$/).nil?
          @posts_and_headlines.preview_straight_copy file
        else
          @posts_and_headlines.preview_rebuild file
        end
      end
    end

    # delete build file from posts, then posts entry
    # rebuild the headline files... and the tags...
    def on_source_delete(path)
      path.each do |file|
        if !file.nil? && (file =~ /^.+\.md$/).nil?
          @posts_and_headlines.preview_straight_delete file
        else
          @posts_and_headlines.preview_delete file
        end
      end
    end

    def watch_build_dir
      listener = Listen.to(@build_directory) do |modified, added, removed|
        on_build_change modified unless modified.empty?
        on_build_change added unless added.empty?
        on_build_delete removed unless removed.empty?
      end
      listener.start
      @listener_array << listener
    end

    def watch_source_dir
      listener = Listen.to(@source_directory) do |modified, added, removed|
        on_source_change modified unless modified.empty?
        on_source_change added unless added.empty?
        on_source_delete removed unless removed.empty?
      end
      listener.start
      @listener_array << listener
    end
  end
end
