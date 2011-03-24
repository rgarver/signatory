$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'signatory/ruby_hacks'
require 'rubygems'
require 'bundler/setup'
require 'yaml'            unless defined?(YAML)
require 'oauth'           unless defined?(OAuth)
require 'active_resource' unless defined?(ActiveResource)

module Signatory
  class << self
    def credentials=(creds)
      if !creds.is_a?(Credentials)
        creds = Credentials.load(creds)
      end
      @credentials = creds
    end
    def credentials; @credentials; end
  end
end

require 'signatory/version'
require 'signatory/api/connection'
require 'signatory/api/base'
require 'signatory/credentials'
require 'signatory/document'
require 'signatory/document_package'
require 'signatory/template'
require 'signatory/role'
require 'signatory/merge_field'
require 'signatory/recipient'

require 'active_resource/version'
if ActiveResource::VERSION::STRING < '3.0.0'
  require 'signatory/legacy_active_resource_hacks'
end
