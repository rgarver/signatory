module Signatory
  class Template < API::Base
    def prepackage
      record = connection.format.decode(post(:prepackage).body)
      Template.instantiate_record(record)
    end

    def build_document(merge_fields, roles)
      doc_pkg = prepackage
      doc_pkg.prefill_and_send(merge_fields, roles)
    end

    def prefill_and_send(merge_fields, roles)
      attributes.merge!({
        'merge_fields' => merge_fields,
        'roles' => roles,
        'action' => 'send'
      })

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
      record['roles'] = [record['roles']['role']].flatten unless record['roles'].nil? || record['roles'].is_a?(Array)
      record['merge_fields'] = [record['merge_fields']['merge_field']].flatten unless record['merge_fields'].nil? || record['merge_fields'].is_a?(Array)

      super(record, opts)
    end
  end
end
