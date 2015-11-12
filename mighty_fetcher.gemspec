# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mighty_fetcher/version'

Gem::Specification.new do |spec|
  spec.name          = 'mighty_fetcher'
  spec.version       = MightyFetcher::VERSION
  spec.authors       = ['Tema Bolshakov']
  spec.email         = ['abolshakov@spbtv.com']

  spec.summary       = 'Mighty resource fetchers'
  spec.description   = 'Mighty resource fetchers build on top of Ransack gem'
  spec.homepage      = ''

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '>= 3.2'
  spec.add_runtime_dependency 'activemodel', '>= 3.2'
  spec.add_runtime_dependency 'uber', '~> 0.0.15'
  spec.add_runtime_dependency 'ibsciss-middleware', '~> 0.3'
  spec.add_runtime_dependency 'ransack', '~> 1.7.0'
  spec.add_development_dependency 'activerecord', '>= 3.2'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.34.2'
end
