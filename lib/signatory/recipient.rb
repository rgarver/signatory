module Signatory
  class Recipient < API::Base
    def document=(doc)
      @document = doc
    end

    def embed_url(redirect_url)
      signer_links = @document.get(:signer_links, "redirect_location" => CGI.escape(redirect_url))
      signer = [signer_links['signer_links']['signer_link']].flatten.select do |s|
        s['role'] == role_id
      end.first
      "https://rightsignature.com/signatures/embedded?rt=#{signer['signer_token']}"
    end
  end
end