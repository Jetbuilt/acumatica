
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "acumatica/version"

Gem::Specification.new do |spec|
  spec.name     = "acumatica"
  spec.version  = Acumatica::VERSION
  spec.authors  = ["Jared Moody"]
  spec.email    = ["jared@jetbuilt.com"]

  spec.summary  = 'A wrapper for the acumatica API'
  spec.homepage = "https://github.com/jetbuilt/acumatica"
  spec.license  = "MIT"

  spec.files    = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7.0"
  spec.add_development_dependency "rubocop", "~> 0.55.0"
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "activesupport"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday-cookie_jar"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "json"
end
