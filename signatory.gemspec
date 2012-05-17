# -*- encoding: utf-8 -*-
require File.expand_path("../lib/signatory/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "signatory"
  s.version     = Signatory::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Garver"]
  s.email       = ["ragarver@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/signatory"
  s.summary     = "API wrapper for RightSignature"
  s.description = "Signatory provides a simple wrapper around the RightSignature API."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "signatory"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", "= 2.5.0"
  s.add_development_dependency "webmock", "= 1.3.5"

  s.add_dependency "bundler", ">= 1.0.0"
  s.add_dependency "oauth", "= 0.4.3"
  s.add_dependency "activeresource", ">= 2.3.9"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
