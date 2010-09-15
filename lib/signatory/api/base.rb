module Signatory
  module API
    class Base
      def initialize(args)
        @args = args
      end

      def method_missing(name)
        @args[name.to_s]
      end

      def id
        guid
      end

      class << self
        def inherited(base)
          name = base.name.split('::').last.downcase
          plural_name = name + 's'

          base.base_path "/api/#{plural_name}"
          base.trim_collection_xml plural_name, name
          base.trim_member_xml name
        end

        def base_path(path)
          @base_path = path
        end

        def trim_collection_xml(*prefix)
          @collection_xml_prefix = prefix
        end

        def trim_member_xml(*prefix)
          @member_xml_prefix = prefix
        end

        def all
          parse_collection(Signatory.get("#{@base_path}.xml"))
        end

        def find(id)
          parse(Signatory.get("#{@base_path}/#{id}.xml"))
        end

        def parse_collection(collection)
          [trim_prefix(collection, @collection_xml_prefix)].flatten.map do |d|
            parse(d)
          end
        end

        def parse(member)
          new(trim_prefix(member, @member_xml_prefix) || member)
        end

        def trim_prefix(hash, prefix)
          prefix.inject(hash){|acc, val| acc[val.to_s]}
        end
      end
    end
  end
end