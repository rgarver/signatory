module Signatory
  class Document < API::Base
    trim_collection_xml :page, :documents, :document
  end
end