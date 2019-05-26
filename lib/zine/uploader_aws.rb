# frozen_string_literal: true

require 'aws-sdk-cloudfront'
require 'aws-sdk-s3'
require 'rack/mime'
require 'rainbow'
require 'set'

module Zine
  # Deploy changes to an AWS S3 bucket and invalidate the Cloudfront cache
  class UploaderAWS
    def initialize(build_dir, options, credentials, delete_file_array,
                   upload_file_array)
      return unless options['method'] == 'aws'

      @build_dir = build_dir
      ENV['AWS_REGION'], @bucket_name = options['host'].split(':')
      @path = options['path_or_repo']
      @cf_distribution_id = options['cloudfront_distrib']

      @verbose = options['verbose']
      store_credentials credentials
      @delete_file_array = Set.new(delete_file_array).to_a
      @upload_file_array = Set.new(upload_file_array).to_a

      @s3 = Aws::S3::Client.new
      @cf = Aws::CloudFront::Client.new
    end

    def upload
      delete
      deploy
      invalidate
    rescue Aws::S3::Errors::ServiceError => err
      puts Rainbow("S3 error: #{err}").red
    end

    private

    def clean_path(path)
      path.to_s
          .delete_prefix('/')
          .delete_suffix('/')
    end

    def delete
      @delete_file_array.each do |rel_path|
        remote_path = clean_path(rel_path)
        @s3.delete_object(bucket: @bucket_name, key: remote_path)
        puts "Delete: #{remote_path}" if @verbose
      end
    end

    def deploy
      @upload_file_array.each do |rel_path|
        deploy_one_file(File.join(@build_dir, rel_path),
                        clean_path(rel_path))
      end
    end

    def deploy_one_file(local_path, remote_path)
      File.open(local_path, 'rb') do |file|
        content_type = Rack::Mime.mime_type(File.extname(local_path))
        @s3.put_object(bucket: @bucket_name,
                       key: remote_path,
                       content_type: content_type,
                       body: file)
        puts "Add: #{remote_path}" if @verbose
      end
    end

    def invalidate
      changes = Set.new(@upload_file_array + @delete_file_array).to_a
      return unless changes.count.positive?

      puts 'Invalidating cache' if @verbose
      string_changes = changes.map do |path|
        path.to_s
            .delete_prefix('/')
            .prepend('/')
      end
      string_changes << '/'
      @cf.create_invalidation(
        distribution_id: @cf_distribution_id,
        invalidation_batch: { paths: { quantity: string_changes.count,
                                       items: string_changes },
                              caller_reference: Time.now.to_i.to_s }
      )
    end

    def store_credentials(creds)
      ENV['AWS_ACCESS_KEY_ID'] = creds['username']
      ENV['AWS_SECRET_ACCESS_KEY'] = creds['password']
    end
  end
end
