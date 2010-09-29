module Signatory
  class Recipient < API::Base
    def document=(doc)
      @document = doc
    end

    def embed_url(redirect_url, options={})
      signer_links = @document.get(:signer_links, "redirect_location" => redirect_url)
      signer = [signer_links['signer_links']['signer_link']].flatten.select do |s|
        s['role'] == role_id
      end.first
      options.merge!(:rt => signer['signer_token'])
      params = options.map{|k,v| "#{k}=#{v}"}.flatten.join('&')
      "https://rightsignature.com/signatures/embedded?#{params}"
    end

    def embed_code(redirect_url, options={})
      args = ['frameborder="0"', 'scrolling="no"']
      args << "width=\"#{options[:width]}px\"" if options.has_key?(:width)
      args << "height=\"#{options[:height]}px\"" if options.has_key?(:height)
      "<iframe src =\"#{embed_url(redirect_url, options)}\" #{args.join(' ')}><p>Your browser does not support iframes.</p></iframe>"
    end
  end
end