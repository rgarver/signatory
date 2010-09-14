module Signatory
  class Credentials
    attr_accessor :key, :secret

    def initialize(key, secret)
      @key, @secret = key, secret
    end

    def self.load(file)
      h = YAML.load(file)
      new(h['key'], h['secret'])
    end
  end
end