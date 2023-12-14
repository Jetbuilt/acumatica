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

  spec.metadata      = { "rubygems_mfa_required" => "true" }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency "activesupport"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday-cookie_jar"
end
