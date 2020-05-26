# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zine/version'

Gem::Specification.new do |spec|
  spec.name = 'zine'
  spec.version       = Zine::VERSION
  spec.authors       = ['Mike Kreuzer']
  spec.email         = ['mike@mikekreuzer.com']

  spec.summary       = 'Yet another blog aware static site generator.'
  spec.description   = 'Yet another blog aware static site generator.
There are many like it, but this one is mine.'
  spec.homepage      = 'https://mikekreuzer.com/projects/zine/'
  spec.license       = 'MIT'

  spec.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md CHANGELOG.md]
  spec.bindir        = 'bin'
  spec.executables   = 'zine'
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3' # to match bundler, kramdown, etc

  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4' # '~> 2.0', '>= 2.0.1'
  spec.add_development_dependency 'curb', '~> 0.9.10' # '~> 0.9.6'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  spec.add_development_dependency 'rspec', '~> 3.9' # '~> 3.8'
  spec.add_development_dependency 'simplecov', '~> 0.18.5' # '~> 0.17.1'

  spec.add_dependency 'aws-sdk-cloudfront', '~> 1.27', '>= 1.27.1' # '~> 1.18'
  spec.add_dependency 'aws-sdk-s3', '~> 1.66' # '~> 1.40'
  # spec.add_dependency 'faraday', '= 0.17.0' # only until octokit > 4.14.0
  spec.add_dependency 'htmlcompressor', '~> 0.4.0'
  spec.add_dependency 'kramdown', '~> 2.2', '>= 2.2.1' # '~> 2.1'
  spec.add_dependency 'kramdown-parser-gfm', '~> 1.1' # '~> 1.0', '>= 1.0.1'
  spec.add_dependency 'listen', '~> 3.2', '>= 3.2.1' # '~> 3.0', '>= 3.1.5'
  spec.add_dependency 'net-sftp', '~> 2.1', '>= 2.1.2' # version 3 to investigate
  spec.add_dependency 'octokit', '~> 4.18' # '~> 4.0'
  spec.add_dependency 'rainbow', '~> 3.0'
  spec.add_dependency 'sassc', '~> 2.3' # '~> 2.0'
  spec.add_dependency 'thin', '~> 1.7'
  spec.add_dependency 'thor', '~> 1.0', '>= 1.0.1' # '~> 0.19', '>= 0.19.4'
end
