module Signatory
  class MergeField < API::Base
    def locked
      attributes['locked'] || true
    end

    def id; attributes['id']; end

    def to_xml(options = {})
      identifier = {}
      identifier.merge!({:merge_field_id => id}) unless attributes['id'].nil?
      identifier.merge!({:merge_field_name => name}) unless attributes['name'].nil?
      require 'builder' unless defined? ::Builder
      options[:indent] ||= 2
      xml = options[:builder] ||= ::Builder::XmlMarkup.new(:indent => options[:indent])
      xml.tag!('merge-field', identifier) do
        if attributes['value'].nil?
          xml.page page
          xml.name name
          xml.id id
        else
          xml.value value
          xml.locked locked
        end
      end
    end
  end
end