module Signatory
  class Document < API::Base
    has_many :recipients

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
