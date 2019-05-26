lib = File.expand_path('../lib', __FILE__)
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
  spec.homepage      = 'https://zine.dev'
  spec.license       = 'MIT'

  spec.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md CHANGELOG.md]
  spec.bindir        = 'bin'
  spec.executables   = 'zine'
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3' # to match bundler, kramdown, etc

  spec.add_development_dependency 'bundler', '~> 2.0', '>= 2.0.1'
  spec.add_development_dependency 'curb', '~> 0.9.6'
  spec.add_development_dependency 'rake', '~> 12.3', '>= 12.3.2'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'

  spec.add_dependency 'aws-sdk-cloudfront', '~> 1.18'
  spec.add_dependency 'aws-sdk-s3', '~> 1.40'
  spec.add_dependency 'htmlcompressor', '~> 0.4.0'
  spec.add_dependency 'kramdown', '~> 2.1'
  spec.add_dependency 'kramdown-parser-gfm', '~> 1.0', '>= 1.0.1'
  spec.add_dependency 'listen', '~> 3.0', '>= 3.1.5'
  spec.add_dependency 'net-sftp', '~> 2.1', '>= 2.1.2'
  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'rainbow', '~> 3.0'
  spec.add_dependency 'sassc', '~> 2.0'
  spec.add_dependency 'thin', '~> 1.7'
  spec.add_dependency 'thor', '~> 0.19', '>= 0.19.4'
end
