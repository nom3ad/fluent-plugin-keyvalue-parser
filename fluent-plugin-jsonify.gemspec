# coding: utf-8
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-keyvalue-parser"
  spec.version       = "0.1.2"
  spec.authors       = ["Arun M J"]
  spec.email         = ["arunmj001@gmail.com"]
  spec.homepage      = "https://github.com/arunmj/fluent-plugin-keyvalue-parser"
  spec.description   = %q{Fluent parser plugin to parse key-value pairs}
  spec.summary       = %q{Fluent parser plugin to parse key-value pairs}
  spec.license       = "MIT"
  spec.has_rdoc      = false

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{| f | File.basename(f)}
  spec.require_paths = ['lib']

  spec.add_dependency 'fluentd', "~> 0.10"
  spec.add_development_dependency "rake", ">0"
  spec.add_development_dependency "rspec", ">0"

  spec.required_ruby_version = '~> 2.0'
end
