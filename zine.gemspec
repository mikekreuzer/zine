# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zine/version'

Gem::Specification.new do |spec|
  spec.name = 'zine'
  spec.version       = Zine::VERSION
  spec.authors       = ['Mike Kreuzer']
  spec.email         = ['mike@mikekreuzer.com']

  spec.summary       = 'Yet another blog aware static site generator.'
  # spec.description   = %q{TODO: Write a longer description or delete.}
  spec.homepage      = 'https://github.com/mikekreuzer/zine'
  spec.license       = 'MIT'

  spec.files = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  spec.bindir        = 'bin'
  spec.executables   = 'zine'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.12'

  spec.add_dependency 'htmlcompressor', '~> 0.3'
  spec.add_dependency 'kramdown', '~> 1.13'
  spec.add_dependency 'rainbow', '~> 2.2'
  spec.add_dependency 'thin', '~> 1.7'
  spec.add_dependency 'thor', '~> 0.19'
end
