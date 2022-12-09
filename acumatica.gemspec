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

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-rubocop"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.40"
  spec.add_development_dependency "rubocop-performance", "~> 1.15.0"
  spec.add_development_dependency "rubocop-rspec", "~> 2.15.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "activesupport"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday-cookie_jar"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "json"
end
