class Signatory
  class Credentials
    attr_accessor :key, :secret

    def initialize(key, secret)
      @key, @secret = key, secret
    end

    def self.load(source)
      h = if source.respond_to?(:read)
        YAML.load(source)
      elsif source.is_a?(Hash)
        source.inject({}){ |acc, (k, v)| acc[k.to_s] = v; acc}
      end

      new(h['key'], h['secret'])
    end
  end
end