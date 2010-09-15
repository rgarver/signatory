$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

unless defined?(YAML)
  require 'yaml'
end

require 'httparty'

module Signatory
  include HTTParty
  base_uri 'https://rightsignature.com'
  format :xml

  VERSION = '0.0.1'

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

require 'signatory/api/base'
require 'signatory/credentials'
require 'signatory/document'
require 'signatory/template'