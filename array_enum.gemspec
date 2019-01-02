
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "array_enum/version"

Gem::Specification.new do |spec|
  spec.name          = "array_enum"
  spec.version       = ArrayEnum::VERSION
  spec.authors       = ["Wojciech Wnętrzak"]
  spec.email         = ["w.wnetrzak@gmail.com", "eng@freeletics.com"]

  spec.summary       = %q{String to integer mapping for PostgreSQL array columns.}
  spec.description   = %q{Extension for ActiveRecord that adds support for PostgreSQL array columns, mapping string values to integers.}
  spec.homepage      = "https://github.com/freeletics/array_enum"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/freeletics/array_enum"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3"

  spec.add_dependency "activemodel"

  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest", ">= 5.0"
end
