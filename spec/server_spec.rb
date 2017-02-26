require 'curb'
require 'date'
require 'rainbow'
require 'spec_helper'
require 'zine/server'

describe 'Zine::Server#new' do
  describe 'starts a server' do
    def start_a_server_in_the_background
      Process.fork do
        Signal.trap('INT') { @thin.stop! unless @thin.nil?; exit }
        options = { 'method' => 'none', 'test' => true }
        begin
          @thin = Zine::Server.new Dir.pwd, options, [], []
        rescue RuntimeError
          puts Rainbow('Unable to start server - already running?').red
        end
      end
    end

    before(:all) do
      # requires writing to a file
      File.open('index.html', 'w') { |file| file.write('<p>hello world</p>') }
      c = Curl::Easy.new('http://127.0.0.1:8080/')
      @headers = {}
      c.on_header do |data|
        data_array = data.split(': ', 2)
        @headers[data_array[0]] = data_array[1].strip unless data_array[1].nil?
        data.length
      end
      pid = start_a_server_in_the_background
      sleep 1
      c.perform
      begin
        Process.kill 'INT', pid
      rescue Errno::EINVAL && RangeError && ArgumentError
        puts Rainbow('Server process could not be killed').red
        Process.wait pid
      end
      File.delete 'index.html'
    end

    it 'responds with headers to discourage caching' do
      expect(@headers['Content-Type']).to eql 'text/html'
      str = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'
      expect(@headers['Cache-Control']).to eql str
      expect(@headers['Connection']).to eql 'keep-alive'
      expect(@headers['Content-Length'].to_i).to be > 0
      expect(DateTime.parse(@headers['Expires'])).to be < DateTime.now
      expect(DateTime.parse(@headers['Last-Modified'])).to be > DateTime.now
      expect(@headers['Pragma']).to eql 'no-cache'
      expect(@headers['Server']).to eql 'thin'
    end
  end
end
