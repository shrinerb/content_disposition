lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "content_disposition/version"

Gem::Specification.new do |spec|
  spec.name          = "content_disposition"
  spec.version       = ContentDisposition::VERSION
  spec.authors       = ["Jonathan Rochkind"]
  spec.email         = ["jrochkind@chemheritage.org"]

  spec.required_ruby_version = ">= 2.3"

  spec.summary       = %q{Ruby gem to create HTTP Content-Disposition headers with proper escaping/encoding of filenames}
  spec.homepage      = "https://github.com/shrinerb/content_disposition"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/*.rb", "*.gemspec"]
  spec.require_path = "lib"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
