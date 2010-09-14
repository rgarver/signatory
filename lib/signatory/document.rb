class Signatory
  class Document
    def initialize(args={})
      @args = args
    end

    def id
      guid
    end

    def method_missing(name)
      @args[name.to_s]
    end

    class << self
      def all
        parse_collection(Signatory.get('/api/documents.xml'))
      end

      def find(id)
        parse(Signatory.get("/api/documents/#{id}.xml"))
      end

      def parse_collection(collection)
        [collection['page']['documents']['document']].flatten.map do |d|
          parse(d)
        end
      end

      def parse(doc)
        new(doc['document'] || doc)
      end
    end
  end
end