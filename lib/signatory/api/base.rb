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

        def connection(refresh = false)
          if defined?(@connection) || superclass == Object
            @connection = Signatory::API::Connection.new(site, format) if refresh || @connection.nil?
            @connection.proxy = proxy if proxy
            @connection.user = user if user
            @connection.password = password if password
            @connection.auth_type = auth_type if auth_type
            @connection.timeout = timeout if timeout
            @connection.ssl_options = ssl_options if ssl_options
            @connection
          else
            superclass.connection
          end
        end
      end
    end
  end
end