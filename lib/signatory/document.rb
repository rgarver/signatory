module Signatory
  class Document < API::Base
    has_many :recipients
    escape_url_attrs :signed_pdf_url, :pdf_url, :original_url, :thumbnail_url

    def extend_expiration
      connection.post("#{self.class.site}documents/#{id}/extend_expiration")
    end

    def expired?
      Date.parse(expires_on) < Date.today
    end

    private
    def self.instantiate_record(record, opts = {})
      super(record, opts).tap do |doc|
        doc.recipients.each {|r| r.document = doc }
      end
    end
  end
end
