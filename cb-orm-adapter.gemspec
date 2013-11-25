# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cb-orm-adapter/version'

Gem::Specification.new do |spec|
  spec.name          = "cb-orm-adapter"
  spec.version       = CbOrmAdapter::VERSION
  spec.authors       = ["Mike Evans"]
  spec.email         = ["mike@urlgonomics.com"]
  spec.description   = %q{}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'orm_adapter', '>= 0.5.0'
  if defined?(JRUBY_VERSION)
    spec.add_dependency 'couchbase-jruby-model', '>= 0.1.0'
  else
    spec.add_dependency 'couchbase-model', '>= 0.5.3'
  end

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
