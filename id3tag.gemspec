require File.expand_path('../lib/id3tag/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "id3tag"
  s.version = ID3Tag::VERSION
  s.authors = ["Krists Ozols"]
  s.email = "krists.ozols@gmail.com"
  s.description = "Native Ruby ID3 tag reader that aims for 100% coverage of ID3v2.x and ID3v1.x standards"
  s.summary = "Native Ruby ID3 tag reader that aims for 100% coverage of ID3v2.x and ID3v1.x standards"
  s.homepage = "https://github.com/krists/id3tag"
  s.license = "MIT"

  s.files         = Dir["lib/**/*.rb"]
  s.executables   = []
  s.extra_rdoc_files = ["LICENSE.txt", "README.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2")

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake", "~> 13.0.1"
  s.add_development_dependency "rdoc", "~> 6.2.1"
  s.add_development_dependency "rspec", "~> 3.9.0"
  s.add_development_dependency "simplecov", "~> 0.16.1"
  s.add_development_dependency 'coveralls', "~> 0.8.23"
  s.add_development_dependency 'pry', "~> 0.13.1"
end
