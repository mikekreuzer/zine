require 'octokit'
require 'rainbow'
require 'yaml'
require 'zine'

module Zine
  # Upload a file to GitHub using its REST API
  class UploaderGitHub
    # Requires zine.yaml to have a path to a credentials yaml file with
    # access_token: ...
    # For instructions on how to create an access token:
    # https://help.github.com/articles/creating-an-access-token-for-command-line-use/
    def initialize(build_dir, options, credentials, delete_file_array,
                   upload_file_array)
      return unless options['method'] == 'github'
      @build_dir = build_dir
      @repo_full_name = options['path_or_repo']
      @client = Octokit::Client.new(access_token: credentials['access_token'])
      @verbose = options['verbose']
      @credentials = credentials
      @delete_file_array = delete_file_array
      @upload_file_array = upload_file_array
    end

    # Duplicates within & between the files already removed in Zine::Upload
    # then .each... upload & delete - uses @build_dir to create relative paths
    def upload
      @delete_file_array.each do |file_pathname|
        delete_file file_pathname
      end
      @upload_file_array.each do |file_pathname|
        upload_file file_pathname
      end
    end

    private

    # see if file exists, then delete it if it does
    # returns commit hash (unused)
    def delete_file(rel_path)
      info_hash = info github_path
      @client.delete_contents(@repo_full_name,
                              rel_path,
                              'Zine delete', # commit message
                              info_hash[:sha],
                              branch: 'gh-pages')
      puts "Deleted #{github_path}" if @verbose
    rescue Octokit::NotFound
      puts "Tried to delete nonexistent remote file #{github_path}"
    end

    # return info on a file if it exsists, otherwise throws Octokit::NotFound
    def info(github_path)
      Octokit.contents(@repo_full_name,
                       path: github_path,
                       ref: 'gh-pages')
    end

    # see if file exists on GitHub, then either create or update it
    # returns hash including [:content][:sha] (unused)
    def upload_file(rel_path)
      info_hash = info rel_path
      upload_update rel_path, info_hash[:sha]
    rescue Octokit::NotFound
      upload_create rel_path
    end

    def upload_create(rel_path)
      res = @client.create_contents(@repo_full_name,
                                    rel_path,
                                    'Zine upload', # commit message
                                    file: File.join(@build_dir, rel_path),
                                    branch: 'gh-pages')
      puts "Created #{res[:content][:path]}" if @verbose
    end

    def upload_update(rel_path, sha)
      res = @client.update_contents(@repo_full_name,
                                    rel_path,
                                    'Zine upload', # commit message
                                    sha,
                                    file: File.join(@build_dir, rel_path),
                                    branch: 'gh-pages')
      puts "Updated #{res[:content][:path]}" if @verbose
    end
  end
end
