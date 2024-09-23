# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-flatten_filter"
  spec.version       = File.read("VERSION").strip
  spec.authors       = ["Andrew Pickin"]
  spec.email         = ["Andrew.Pickin@epimorphics.com"]

  spec.summary       = "Fluent pluggin to flatten keys"
  spec.description   = "Fluent pluggin to keys specified key by replacing '.' with another charater (default '_'). Optionally recursive"
  spec.homepage      = "https://github.com/epimorphics/fluent-plugin-flatten_filter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.7"

  spec.add_runtime_dependency "fluentd", ">= 0.14.0", "< 2"

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "test-unit", "~> 3"
end
