# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esp_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'esp_sdk'
  spec.version       = ESP::VERSION
  spec.authors       = ['Evident.io']
  spec.email         = ['support@evident.io']
  spec.summary       = "SDK for interacting with the ESP API."
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'shoulda'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'coveralls'

  spec.add_dependency 'activeresource', '~> 4.0.0'
  spec.add_dependency 'api-auth'
  spec.add_dependency 'rest-client' # , '~> 1.7.3'
  spec.add_dependency 'pry'
  spec.add_dependency 'awesome_print'
  spec.add_dependency 'artii'
end
