module Signatory
  class Credentials
    attr_accessor :key, :secret, :access_token, :access_secret, :api_version

    def initialize(key, secret, access_token, access_secret, api_version='1.2')
      $stderr.puts "Deprecation Warning: Signatory is now compatible with RightSignature API version 1.2, you have chosen #{api_version}.  Please upgrade." if api_version != '1.2'
      @key, @secret, @access_token, @access_secret, @api_version = key, secret, access_token, access_secret, api_version
    end

    def self.load(source)
      h = if source.respond_to?(:read)
        YAML.load(source)
      elsif source.is_a?(Hash)
        source.inject({}){ |acc, (k, v)| acc[k.to_s] = v; acc}
      end

      new(h['key'], h['secret'], h['access_token'], h['access_secret'], h['api_version']||'1.2')
    end

    def token
      @consumer ||= OAuth::Consumer.new(key, secret, {
        :site               => 'https://rightsignature.com',
        :scheme             => :header,
        :http_method        => :post,
        :request_token_path => "/oauth/request_token",
        :access_token_path  => "/oauth/access_token",
        :authorize_path     => "/oauth/authorize"
      })
      @token ||= OAuth::AccessToken.new(
        @consumer,
        access_token,
        access_secret
      )
    end
  end
end
