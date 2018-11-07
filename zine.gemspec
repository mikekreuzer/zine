
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
These are the very early days of zine, expect breaking changes.'
  spec.homepage      = 'https://github.com/mikekreuzer/zine'
  spec.license       = 'MIT'

  spec.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md CHANGELOG.md]
  spec.bindir        = 'bin'
  spec.executables   = 'zine'
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.2' # to match rails

  spec.add_development_dependency 'bundler', '~> 1.16', '>= 1.16.4'
  spec.add_development_dependency 'curb', '~> 0.9.6'
  spec.add_development_dependency 'rake', '~> 12.3', '>= 12.3.1'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'

  # spec.add_dependency 'concurrent-ruby'
  spec.add_dependency 'highline', '~> 2.0' # duplicates thor
  spec.add_dependency 'htmlcompressor', '~> 0.4.0'
  spec.add_dependency 'kramdown', '~> 1.17'
  spec.add_dependency 'listen', '~> 3.0', '>= 3.1.5'
  spec.add_dependency 'net-sftp', '~> 2.1', '>= 2.1.2'
  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'rainbow', '~> 3.0'
  spec.add_dependency 'sassc', '~> 2.0'
  spec.add_dependency 'thin', '~> 1.7'
  spec.add_dependency 'thor', '~> 0.19', '>= 0.19.4'
end
