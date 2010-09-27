module Signatory
  class Template < API::Base
    def prepackage
      record = connection.format.decode(post(:prepackage).body)
      Template.instantiate_record(record)
    end

    private
    def self.instantiate_record(record, opts = {})
      DocumentPackage.send(:instantiate_record, record, opts) if record.delete('type') == 'DocumentPackage'
      record['roles'] = [record['roles']['role']].flatten unless record['roles'].nil? || record['roles'].is_a?(Array)
      record['merge_fields'] = [record['merge_fields']['merge_field']].flatten unless record['merge_fields'].nil? || record['merge_fields'].is_a?(Array)

      super(record, opts)
    end
  end
end
