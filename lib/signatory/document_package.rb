module Signatory
  class DocumentPackage < API::Base
    self.element_name = "template"
    has_many :roles
    has_many :merge_fields
    def self.all; raise NoMethodError; end
    def self.find; raise NoMethodError; end

    def prefill_and_send(merge_fields, roles, opts={})
      attributes.merge!({
        'merge_fields' => merge_fields,
        'roles' => roles,
        'action' => 'send'
      })
      if opts[:document_data].present?
        attributes.merge!({
          'document_data' => {
            'type' => 'base64',
            'filename' => 'document.pdf',
            'value' => Base64.encode64(opts[:document_data])
          }
        })
      end

      doc = connection.format.decode(connection.post("/api/templates.xml", self.to_xml).body)
      Document.find(doc['guid'])
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
