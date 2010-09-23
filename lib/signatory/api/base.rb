require 'active_resource'

module Signatory
  module API
    class Base < ActiveResource::Base
      self.site = 'https://rightsignature.com/api/'

      def id
        guid
      end

      class << self
        def instantiate_collection(collection, opts)
          if collection.has_key?(formatted_collection_name)
            collection = collection[formatted_collection_name]
          end
          super([collection[formatted_name]].flatten, opts)
        end

        def formatted_name
          self.name.split('::').last.downcase
        end

        def formatted_collection_name
          self.name.split('::').last.downcase.pluralize
        end
      end
    end
  end
end