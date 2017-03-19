require 'spec_helper'
require 'zine'
require 'zine/uploader_github'

describe 'Zine::UploaderGitHub' do
  before(:all) do
    @uploader = Zine::UploaderGitHub.new('',
                                         { 'path_or_repo' => 'a/b',
                                           'method' => 'github' },
                                         { 'access_token' => 'ok' },
                                         %w(delete),
                                         %w(upload_exists upload_new))
  end
  before(:each) do
    allow_any_instance_of(Octokit::Client)
      .to receive(:new)
      .and_return(nil)
  end

  describe '#upload' do
    it 'calls #delete_file against the @delete_file_array' do
      # only tests this hapens once, not for each
      allow_any_instance_of(Zine::UploaderGitHub)
        .to receive(:delete_file)
        .and_throw(:delete, 'delete world')

      delete_result = catch :delete do
        @uploader.upload
        raise 'should not get here'
      end
      expect(delete_result).to eql('delete world')
    end

    it 'calls #upload_file on each element of @delete_file_array' do
      allow_any_instance_of(Zine::UploaderGitHub)
        .to receive(:delete_file)
        .and_return(nil)
      allow_any_instance_of(Zine::UploaderGitHub)
        .to receive(:upload_file)
        .and_return(nil)

      upload_result_array = @uploader.upload
      expect(upload_result_array.length).to eql(2)
    end
  end

  describe '#delete_file, #upload_file, #upload_create and #upload_update' do
    it 'is driven by Octokit.contents returning a file hash or not' do
      allow(Octokit)
        .to receive(:contents)
        .with('a/b', path: 'delete', ref: 'gh-pages')
        .and_return(sha: 'file hash')
      allow(Octokit)
        .to receive(:contents)
        .with('a/b', path: 'upload_exists', ref: 'gh-pages')
        .and_return(sha: 'file hash')
      allow(Octokit)
        .to receive(:contents)
        .with('a/b', path: 'upload_new', ref: 'gh-pages')
        .and_raise(Octokit::NotFound)
      allow_any_instance_of(Octokit::Client)
        .to receive(:create_contents)
        .with('a/b', 'upload_new', 'Zine upload', file: '/upload_new',
                                                  branch: 'gh-pages')
        .and_return(nil)
      allow_any_instance_of(Octokit::Client)
        .to receive(:delete_contents)
        .with('a/b', 'delete', 'Zine delete', 'file hash', branch: 'gh-pages')
        .and_return(nil)
      allow_any_instance_of(Octokit::Client)
        .to receive(:update_contents)
        .with('a/b', 'upload_exists', 'Zine upload', 'file hash',
              file: '/upload_exists', branch: 'gh-pages')
        .and_return(nil)

      expect(@uploader.upload).to eq %w(upload_exists upload_new)
    end
  end

  describe '#delete_file' do
    it 'outputs an error message if the file doesn\'t exist remotely' do
      uploader2 = Zine::UploaderGitHub.new('',
                                           { 'path_or_repo' => 'a/b',
                                             'method' => 'github' },
                                           { 'access_token' => 'ok' },
                                           %w(missing_file),
                                           [])
      allow(Octokit)
        .to receive(:contents)
        .with('a/b', path: 'missing_file', ref: 'gh-pages')
        .and_raise(Octokit::NotFound)
      error_str = /Tried to delete nonexistent remote file missing_file/
      expect { uploader2.upload }.to output(error_str).to_stdout
    end
  end
end
