# coding: utf-8
require File.expand_path('../lib/id3tag/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "id3tag"
  s.version = ID3Tag::VERSION
  s.authors = ["Krists Ozols"]
  s.email = "krists@iesals.lv"
  s.description = "Native Ruby ID3 tag reader that aims for 100% covarage of ID3v2.x and ID3v1.x standards"
  s.summary = "Native Ruby ID3 tag reader that aims for 100% covarage of ID3v2.x and ID3v1.x standards"
  s.homepage = "http://github.com/krists/id3tag"
  s.license = "MIT"

  s.files = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.extra_rdoc_files = ["LICENSE.txt", "README.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc", "~> 4.1.1"
  s.add_development_dependency "rspec", "~> 2.13.0"
  s.add_development_dependency "simplecov"
  s.add_development_dependency 'coveralls'
end
