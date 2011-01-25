module Signatory
  class Document < API::Base

    def extend_expiration
      connection.post(:extend_expiration)
    end

    def extend_expiration!
      extend_expiration
      reload
    end

    def expired?
      Date.parse(expires_on) < Date.today
    end

    private
    def self.instantiate_record(record, opts = {})
      record['recipients'] = [record['recipients']['recipient']].flatten unless record['recipients'].nil? || record['recipients'].is_a?(Array)

      doc = super(record, opts)
      doc.recipients.each {|r| r.document = doc } if doc.respond_to?(:recipients)
      doc
    end
  end
end