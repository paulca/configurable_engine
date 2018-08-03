# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'configurable_engine/version'

Gem::Specification.new do |spec|
  spec.name = "configurable_engine"
  spec.version = ConfigurableEngine::VERSION

  spec.authors = ["Paul Campbell", 'Michael Glass']
  spec.description = "Configurable is a Rails 4 engine that allows you to set up config variables in a config file, specifying default values for all environmentspec. These variables can then be set on a per-app basis using a user facing configuration screen. "
  spec.email = "paul@rslw.com"
  spec.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]

  spec.files         = Dir["*.txt", "*.md", "lib/**/*", "app/**/*", "config/**/*"] - ['config/cucumber.yml']
  #re-enable test files when they're actually used.  In the mean time, lets leave them out to reduce our gem size.
  #spec.test_files    = Dir['features/**/*', 'spec/**/*', 'gemfiles/**/*'] + %w{config/cucumber.yml .rspec tasks/cucumber.rake}

  spec.homepage = "http://github.com/paulca/configurable_engine"
  spec.licenses = ["MIT"]
  spec.require_paths = ["lib"]
  spec.rubygems_version = "2.0.3"
  spec.summary = "Database-backed configuration for Rails 4, with defaults from config file."

  spec.add_dependency "rails", ">4.2.0"
end
