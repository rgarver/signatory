# Template.prepackage -> creates a send/redirect-able Template
# Documents are "sent" 
module Signatory
  class Template < API::Base
    has_many :roles
    has_many :merge_fields

    def prepackage
      record = connection.format.decode(post(:prepackage).body)
      DocumentPackage.send(:instantiate_record, record)
    end

    def build_document(merge_fields, roles)
      doc_pkg = prepackage
      doc_pkg.prefill_and_send(merge_fields, roles)
    end

    def to_xml(opts = {})
      super(opts.merge(:dasherize => false, :skip_types => true, :except => [:pages, :_type, :redirect_token, :content_type, :size, :tags])) do |b|
        b.tag!(:tags) do
          tags.split(" ").each do |tag|
            b.tag!(:tag) { b.value tag}
          end
        end unless attributes['tags'].blank?
      end
    end

    private
    def self.instantiate_record(record, opts = {})
      record['_type'] = record.delete('type') if record.has_key?('type')

      super(record, opts)
    end
  end
end
