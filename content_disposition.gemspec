
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "content_disposition/version"

Gem::Specification.new do |spec|
  spec.name          = "content_disposition"
  spec.version       = ContentDisposition::VERSION
  spec.authors       = ["Jonathan Rochkind"]
  spec.email         = ["jrochkind@chemheritage.org"]

  spec.summary       = %q{Ruby gem to create HTTP Content-Disposition headers with proper escaping/encoding of filenames}
  spec.homepage      = "https://github.com/shrinerb/content_disposition"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "i18n", "~> 1.0"
  spec.add_development_dependency "byebug"
end
