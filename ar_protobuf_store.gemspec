# -*- encoding: utf-8 -*-

require File.expand_path("../lib/ar_protobuf_store/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "ar_protobuf_store"
  gem.version       = ArProtobufStore::VERSION
  gem.summary       = %q{Serialize Ar attributes with Protocol Buffers}
  gem.description   = %q{Like Ar::Store, but with Protocol Buffers}
  gem.license       = "MIT"
  gem.authors       = ["Hsiu-Fan Wang"]
  gem.email         = "hfwang@porkbuns.net"
  gem.homepage      = "https://rubygems.org/gems/ar_protobuf_store"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "activerecord", ">= 3.0", "< 5.1"

  # Install this by default to make development easier
  gem.add_development_dependency "ruby-protocol-buffers", "~> 1.5"

  gem.add_development_dependency "codeclimate-test-reporter"
  gem.add_development_dependency "pry", "~> 0.9"
  gem.add_development_dependency "sqlite3", "~> 1.3"
  gem.add_development_dependency "appraisal", "~> 1.0.0"
  gem.add_development_dependency "rspec", "~> 3.5.0"
  gem.add_development_dependency "rubygems-tasks", "~> 0.2"
  gem.add_development_dependency "yard", "~> 0.8"
end
