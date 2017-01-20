# coding: utf-8
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-jsonify"
  spec.version       = "0.0.1"
  spec.authors       = ["arun mj"]
  spec.email         = ["arun.muraleedharan@flytxt.com"]
  spec.homepage      = "https://github.com/arunmj/fluent-plugin-jsonify"
  spec.description   = %q{Fluentd parser plugin to parse key-value pairs}
  spec.summary       = %q{Fluentd parser plugin to parse key-value pairs}
  spec.license       = "MIT"
  spec.has_rdoc      = false

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{| f | File.basename(f)}
  spec.require_paths = ['lib']

  spec.add_dependency 'fluentd', "~> 0.10"
  spec.add_development_dependency "rake", ">0"
  spec.add_development_dependency "rspec", ">0"
end
