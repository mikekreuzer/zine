require 'curb'
require 'date'
require 'rainbow'
require 'spec_helper'
require 'zine/server'

describe 'Zine::Server' do
  describe '#new' do
    context 'starts a server, its response headers' do
      before(:all) do
        # requires writing file -- should be via dep. injection
        File.open('index.html', 'w') { |file| file.write('<p>hello world</p>') }
        c = Curl::Easy.new('http://127.0.0.1:8080/')
        @headers = {}
        c.on_header do |data|
          data_array = data.split(': ', 2)
          unless data_array[1].nil?
            @headers[data_array[0]] = data_array[1].strip
          end
          data.length
        end
        pid = Process.fork do
          Signal.trap('INT') do
            @thin.stop! unless @thin.nil?
            exit
          end
          options = { 'method' => 'none', 'test' => true }
          begin
            @thin = Zine::Server.new Dir.pwd, options, [], []
          rescue RuntimeError
            puts Rainbow('Unable to start server - already running?').red
          end
        end
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

      it 'say it\'s text' do
        expect(@headers['Content-Type']).to eql 'text/html'
      end
      it 'set Cache-Control' do
        str = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'
        expect(@headers['Cache-Control']).to eql str
      end
      it 'say to keep the connection alive' do
        expect(@headers['Connection']).to eql 'keep-alive'
      end
      it 'say it has content' do
        expect(@headers['Content-Length'].to_i).to be > 0
      end
      it 'say it expired in the past' do
        expect(DateTime.parse(@headers['Expires'])).to be < DateTime.now
      end
      it 'say it was modified in the future' do
        expect(DateTime.parse(@headers['Last-Modified'])).to be > DateTime.now
      end
      it 'set Pragma = no-cache' do
        expect(@headers['Pragma']).to eql 'no-cache'
      end
      it 'say it\'s a Thin server' do
        expect(@headers['Server']).to eql 'thin'
      end
    end
  end
end
