require 'spec_helper'
require 'zine'
require 'zine/upload'
require 'zine/uploader_github'
require 'zine/uploader_sftp'

describe 'Zine::Upload' do
  describe '#new' do
    context 'upload method in zine.yaml set to none' do
      it 'returns an instance of Zine::Upload that does nothing' do
        options = { 'method' => 'none' }
        do_nothing = Zine::Upload.new '', options, [], []
        expect(do_nothing).to be_instance_of(Zine::Upload)
        expect(do_nothing.upload_decision(nil)).to be nil
      end
    end

    context 'upload method in zine.yaml set anything but none' do
      it 'returns an instance of Zine::Upload that may do something' do
        options = { 'method' => 'gibberish', 'credentials' => 'fake_file.yaml' }
        allow(File)
          .to receive(:open)
          .with('fake_file.yaml', 'r')
          .and_return(
            StringIO.new("---username: mike\npassword: nil\n---\n")
          )
        maybe_do_something = Zine::Upload.new '', options, [], []
        expect(maybe_do_something).to be_instance_of(Zine::Upload)
      end
    end

    context 'badly formed credentials file' do
      it 'outputs a warning about the YAML' do
        options = { 'method' => 'gibberish', 'credentials' => 'bad_file.yaml' }
        allow(File)
          .to receive(:open)
          .with('bad_file.yaml', 'r')
          .and_return(
            StringIO.new("---username: 'what...\n")
          )
        expect do
          Zine::Upload.new '', options, [], []
        end.to output(
          /Could not parse YAML in: bad_file.yaml/
        ).to_stdout
      end
    end
  end

  describe '#upload_decision' do
    # Mock CLI interactions - computer says Yes
    class MockHighlineYes
      def ask(_question)
        'Y'
      end
    end

    # Mock CLI interactions - computer says No
    class MockHighlineNo
      def ask(_question)
        'N'
      end
    end

    before(:each) do
      allow(File)
        .to receive(:open)
        .with('fake_file.yaml', 'r')
        .and_return(
          StringIO.new("---username: mike\npassword: nil\n---\n")
        )
    end

    context 'upload method in zine.yaml set to github; user says upload' do
      it 'Zine::UploaderGithub object created & #upload called' do
        options = { 'method' => 'github', 'credentials' => 'fake_file.yaml' }
        # mocked cerdential files would have an access token, not username & pwd
        allow(Octokit::Client)
          .to receive(:new)
          .and_return(nil)
        allow_any_instance_of(Zine::UploaderGitHub)
          .to receive(:upload)
          .and_return('connection attempt')
        try_and_github = Zine::Upload.new '', options, [], []
        expect do
          expect(try_and_github.upload_decision(MockHighlineYes))
            .to eql 'connection attempt'
        end.to output(/Connecting.../).to_stdout
      end
    end

    context 'upload method in zine.yaml set to sftp; user says upload' do
      it 'Zine::UploaderSFTP object created & #upload called' do
        options = { 'method' => 'sftp', 'credentials' => 'fake_file.yaml' }
        allow(Net::SFTP)
          .to receive(:start)
          .and_return(nil)
        allow_any_instance_of(Zine::UploaderSFTP)
          .to receive(:upload)
          .and_return('connection attempt')
        try_and_sftp = Zine::Upload.new '', options, [], []
        expect do
          expect(try_and_sftp.upload_decision(MockHighlineYes))
            .to eql 'connection attempt'
        end.to output(/Connecting.../).to_stdout
      end
    end

    context 'upload method in zine.yaml anything other than none|github|sftp' do
      it 'outputs a warning if the user replies that they want to upload' do
        options = { 'method' => 'gibberish', 'credentials' => 'fake_file.yaml' }
        do_warning = Zine::Upload.new '', options, [], []
        expect { do_warning.upload_decision(MockHighlineYes) }.to output(
          /Unknown upload option in zine.yaml/
        ).to_stdout
      end
    end

    context 'users says they don\'t want to upload files' do
      it 'does nothing' do
        options = { 'method' => 'sftp', 'credentials' => 'fake_file.yaml' }
        do_nothing = Zine::Upload.new '', options, [], []
        expect(do_nothing.upload_decision(MockHighlineNo)).to eql nil
      end
    end
  end
end
