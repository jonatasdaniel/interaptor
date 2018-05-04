
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "interaptor/version"

Gem::Specification.new do |spec|
  spec.name          = "interaptor"
  spec.version       = Interaptor::VERSION
  spec.authors       = ["Jonatas Daniel Hermann"]
  spec.email         = ["jonatas.hermann@gmail.com"]

  spec.summary       = %q{Interactor gem for ruby apps}
  spec.description   = %q{Easy Interactor gem for ruby apps}
  spec.license       = "MIT"
  spec.homepage      = "https://github.com/jonatasdaniel/interaptor"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
