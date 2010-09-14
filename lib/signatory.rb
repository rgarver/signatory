$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

unless defined?(YAML)
  require 'yaml'
end

module Signatory
  VERSION = '0.0.1'
end

require 'signatory/credentials'